//
//  StarViewController.swift
//  Diary
//
//  Created by 강지원 on 2022/12/29.
//
import UIKit

class StarViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var diaryList = [Diary]()//즐겨찾기뷰에 표시할 다이어리 리스트 배열
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadStarDiaryList()
        self.configureCollectionView()
    }
    //viewDidLoad(): 뷰 컨트롤러의 뷰가 메모리에 로드될 때 한 번만 호출되므로,
    //일반적으로 뷰와 관련된 초기화 코드를 작성하는 데 사용됩니다.
    //이 메소드는 뷰 컨트롤러의 뷰가 처음 생성될 때 한 번만 호출되므로, 이후에는 호출되지 않습니다.
    
    //viewWillAppear(_:): 뷰가 화면에 나타나기 직전에 호출되므로,
    //뷰와 관련된 작업(예: 데이터 로딩, 레이아웃 변경 등)은 주로 이 메소드에서 수행됩니다.
    //이 메소드는 뷰가 화면에 나타날 때마다 호출되므로
    private func configureCollectionView() {
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        //콜렉션뷰레이아웃에 콜렉션뷰플로우레이아웃을 할당
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        //컬렉션뷰의 섹션자체의 탑,레프트,바텀,라이트의 간격을 정할수있다.
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    private func loadStarDiaryList() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "diaryList") as? [[String : Any]] else { return }
        self.diaryList = data.compactMap {
            guard let title = $0["title"] as? String else { return nil }
            guard let contents = $0["contents"] as? String else { return nil }
            guard let date = $0["date"] as? Date else { return nil }
            guard let isStar = $0["isStar"] as? Bool else { return nil }
            return Diary(title: title, contents: contents, date: date, isStar: isStar)
        }.filter({
            $0.isStar == true
        }).sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
    }
    
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}

extension StarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.diaryList.count //지정된 섹션에 표시할 셀의 개수를 정하는 메서드
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {//컬렉션뷰에 표시할 셀을 요청하는 메서드
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StarCell", for: indexPath) as? StarCell else { return UICollectionViewCell() }
        let diary = self.diaryList[indexPath.row]
        cell.TitleLabel.text = diary.title
        cell.DateLabel.text = self.dateToString(date: diary.date)
        return cell
    }
}

extension StarViewController: UICollectionViewDelegate {//컨텐츠의 표현, 사용자와의 상호작용과 관련된것들을 관리하는 객체
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "DiaryDetailViewController") as? DiaryDetailViewController else { return }
        viewController.diary = diaryList[indexPath.row]
        viewController.indexPath = indexPath
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension StarViewController: UICollectionViewDelegateFlowLayout {//셀의 사이즈를 정의하는 메서드
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 20, height: 80)
    }
}

