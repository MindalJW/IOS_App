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
    }
    
    private func configureCollectionView() {
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let wirteDiaryController = segue.destination as? WriteDiaryViewController {
            wirteDiaryController.delegate = self
            //넘어가는 화면이 WriteDiaryViewController으로 다운캐스팅 가능하다면 자신을 위임자로 정함
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
