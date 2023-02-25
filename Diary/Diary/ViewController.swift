//
//  ViewController.swift
//  Diary
//
//  Created by 강지원 on 2022/12/29.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var diaryList = [Diary]() {
        didSet {
            self.saveDiaryList()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        self.loadDiaryList()
        NotificationCenter.default.addObserver(//노티피케이션 옵저버 등록
            self,//옵저빙하는 인스턴스
            selector: #selector(editDiaryNotification),//탐지됐을때 호출되는 함수
            name: NSNotification.Name("editDiary"),//탐지할 노티피케이션 이름
            object: nil)//어디서든 알람 수신가능
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(starDiaryNotification),
            name: NSNotification.Name("StarDiary"),
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(deleteDiaryNotification),
            name: NSNotification.Name("deleteDiary"),
            object: nil)
    }
    
    
    private func configureCollectionView() {
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    @objc func editDiaryNotification(_ notification: Notification) {//노티피케이션 옵저버가 탐지했을때 호출
        guard let diary = notification.object as? Diary else { return }//노티피케이션의 오브젝트를 옵셔널바인딩
        guard let row = notification.userInfo?["indexPath.row"] as? Int else { return }//노티피케이션의 유저인포를 옵셔널바인딩
        self.diaryList[row] = diary//처음에 선택한 다이어리 리스트의 다이어리를 수정한 다이어리로 저장
        self.diaryList = self.diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })//다이어리 리스트를 시간순 정렬
        self.collectionView.reloadData()//콜렉션뷰 새로고침
    }
    
    @objc func starDiaryNotification(_ notification: Notification) {
        guard let starDiary = notification.object as? [String: Any] else { return }
        guard let isStar = starDiary["isStar"] as? Bool else { return }
        guard let indexPath = starDiary["indexPath"] as? IndexPath else { return }
        self.diaryList[indexPath.row].isStar = isStar
    }
    
    @objc func deleteDiaryNotification(_ notification: Notification) {
        guard let deleteDiary = notification.object as? [String: Any] else { return }
        guard let indexPath = deleteDiary["indexPath"] as? IndexPath else { return }
        self.diaryList.remove(at: indexPath.row)
        self.collectionView.deleteItems(at: [indexPath])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let wirteDiaryController = segue.destination as? WriteDiaryViewController {
            wirteDiaryController.delegate = self
            //넘어가는 화면이 WriteDiaryViewController으로 다운캐스팅 가능하다면 자신(ViewController)을 위임자로 정함
        }
    }
    
    private func saveDiaryList() {
        let data = self.diaryList.map { //data는 diaryList의 원소가 딕셔너리형태로 맵핑된 딕셔너리 배열의 형태
            [
                "title": $0.title,
                "contents": $0.contents,
                "date": $0.date,
                "isStar": $0.isStar
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "diaryList")
    }
    
    private func loadDiaryList() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "diaryList") as? [[String : Any]] else { return }
        self.diaryList = data.compactMap {
            guard let title = $0["title"] as? String else { return nil }
            guard let contents = $0["contents"] as? String else { return nil }
            guard let date = $0["date"] as? Date else { return nil }
            guard let isStar = $0["isStar"] as? Bool else { return nil }
            return Diary(title: title, contents: contents, date: date, isStar: isStar)
        }
        self.diaryList = self.diaryList.sorted(by: { //조건이 true일때만 반환 즉, $0의 값이 $1의 값보다 클때만 반환하고 아니라면 순서를 바꾼다.
            $0.date.compare($1.date) == .orderedDescending//내림차순
        })//이런식으로하면 내림차순으로 정렬된다.
        
    }
    
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}



extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.diaryList.count//섹션안의 뷰의 개수 = 다이어리 리스트의 길이
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { //콜렉션뷰의 셀을 그리는 메서드
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryCell", for: indexPath) as? DiaryCell else { return UICollectionViewCell()}
        let diary = self.diaryList[indexPath.row]//다이어리 리스트의 순서대로 콜렉션뷰의 셀을 그림
        cell.titleLabel.text = diary.title//셀의 titleLabel을 다이어리객체의 title프로퍼티로 저장
        cell.dateLabel.text = self.dateToString(date: diary.date)//셀의 dateLabel을 다이어리객체의 date프로퍼티로 저장
        //여기서 Date타입을 text필드에 넣을수 없기떄문에 date포매터를 이용해 문자열로 변환하여 저장
        return cell//셀을 반환
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let Viewcontroller = self.storyboard?.instantiateViewController(identifier: "DiaryDetailViewController") as? DiaryDetailViewController else { return }
        let diary = self.diaryList[indexPath.row]
        Viewcontroller.diary = diary
        Viewcontroller.indexPath = indexPath
        self.navigationController?.pushViewController(Viewcontroller, animated: true)
    }
}

extension ViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width / 2) - 20, height: 200)
        //콜렉션뷰의 사이즈를 정하는 메서드
    }
}

extension ViewController:WriteDiaryViewDelegate {
    func didSelectReigster(diary: Diary) {//위임자가 대신해야하는 기능
        self.diaryList.append(diary)//등록버튼이 눌릴때마다 다이어리리스트에 다이어리 객체 추가
        self.diaryList = diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
        self.collectionView.reloadData()//데이터를 새로고침
    }
}

