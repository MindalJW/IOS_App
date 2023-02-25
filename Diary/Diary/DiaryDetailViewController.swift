//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by 강지원 on 2022/12/29.
//

import UIKit


class DiaryDetailViewController: UIViewController {
    
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var starButton: UIBarButtonItem?
    
    var diary: Diary?
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        NotificationCenter.default.addObserver(//노티피케이션센터 옵저버 등록
            self,//옵저빙하는 인스턴스
            selector: #selector(editDiaryNotification(_:)),//탐지가 되면 실행되는 셀렉터
            name: NSNotification.Name("editDiary"),//노티피케이션 이름
            object: nil)//특정객체에서만 알람을 받는 파라미터를 nil로 설정하여 어디서든 알람을 받을수 있도록함
    }
    
    private func configureView() {//선택된 다이어리 리스트의 다이어리 내용을 다이어리 상세화면에 표시
        guard let diary = self.diary else { return }//다이어리 객체 옵셔널 바인딩
        self.titleLabel.text = diary.title
        self.contentsTextView.text = diary.contents
        self.dateLabel.text = dateToString(date: diary.date)
        self.starButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(tapStarButton))
        self.starButton?.image = diary.isStar ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        self.starButton?.tintColor = .orange
        self.navigationItem.rightBarButtonItem = self.starButton
    }
    
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    @objc func editDiaryNotification(_ notification: Notification) {/*노티피케이션센터 옵저버가
                                                                     포스트된 노티피케이션을 발견했을때 실행되는 함수*/
        guard let diary = notification.object as? Diary else { return }//포스트된 노티피케이션의 오브젝트(다이어리)를 옵셔널 바인딩
        self.diary = diary//옵셔널 바인딩한 노티피케이션의 오브젝트(다이어리)를 자신의 다이어리 변수에 저장
        self.configureView()//상세화면을 보여주는 함수를 재호출
    }
    
    @IBAction func tapEditButton(_ sender: Any) {//수정버튼을 눌렀을때 호출
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "WriteDiaryViewController") as? WriteDiaryViewController else { return }//일기작성화면을 인스턴스화
        guard let indexPath = self.indexPath else { return }//다이어리 리스트에서 선택한 다이어리 객체의 인덱스패치를 옵셔널바인딩
        guard let diary = self.diary else { return }//다이어리 리스트에서 선택한 다이어리 객체를 옵셔널 바인딩
        viewController.diaryEditorMode = .edit(indexPath, diary)/*일기작성화면의 열거형 값을 .edit으로바꾸고 옵셔널바인딩한 인덱스패치와 다이어리 객체를 연관값으로 넘겨줌*/
        self.navigationController?.pushViewController(viewController, animated: true)//수정버튼을 누르면 일기작성화면이 푸쉬
    }
    
    @IBAction func tapDeleteButton(_ sender: Any) {//삭제버튼을 눌렀을때 호출
        guard let indexPath = self.indexPath else { return }//다이어리 리스트에서 선택한 다이어리 객체의 인덱스패치를 옵셔널바인딩
        NotificationCenter.default.post(
            name: NSNotification.Name("deleteDiary"),
            object: ["indexPath": indexPath]
        )
        self.navigationController?.popViewController(animated: true)//다이어리 상세화면을 팝
    }
    
    @objc func tapStarButton() {
        guard let isStar = self.diary?.isStar else { return }
        guard let indexPath = self.indexPath else { return }
        if isStar {
            self.starButton?.image = UIImage(systemName: "star")
        } else {
            self.starButton?.image = UIImage(systemName: "star.fill")
        }
        self.diary?.isStar = !isStar
        NotificationCenter.default.post(
            name: NSNotification.Name("StarDiary"),
            object: ["isStar": self.diary?.isStar ?? false,
                     "indexPath": indexPath
                    ])
        //self.delegate?.didSelectStar(indexPath: indexPath, isStar: self.diary?.isStar ?? false)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)//다이어리 상세화면이 디이닛됐을때 옵저버도 삭제
    }
}
