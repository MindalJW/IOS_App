//
//  ViewController.swift
//  TodoList
//
//  Created by 강지원 on 2022/06/11.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet weak var TableView: UITableView!
    var doneButton: UIBarButtonItem! // doneButton 초기화
    
    var tasks = [Task]() { // 배열에 원소가 추가될때마다 userDefaults에 데이터 저장
        didSet {
            self.saveTasks()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTap)) // doneButton을 UIBarButtonItem메서드를 통해 생성, action을 통해 doneButton이 눌렸을때 호출할 메서드를 selector형태로지정할수있음
        self.TableView.dataSource = self // TableViewdataSource 사용
        self.TableView.delegate = self // TableViewdelegate 사용
        self.loadTasks()//viewDidLoad 생명주기에서 데이터 불러오기
    }
    
    @objc func doneButtonTap() { //doneButton이 눌리면
        self.navigationItem.leftBarButtonItem = self.editButton //leftBarButtonItem이 edit버튼으로 바뀜
        self.TableView.setEditing(false, animated: true) //편집모드를 종료
    }
    
    @IBAction func tapEditButton(_ sender: UIBarButtonItem) {
        guard !self.tasks.isEmpty else { return } // 할일목록이 비어있지 않다면
        self.navigationItem.leftBarButtonItem = self.doneButton // leftBarButtonItem이 done버튼으로 바뀜
        self.TableView.setEditing(true, animated: true) // 편집모드를 실행
    }
    
    @IBAction func tapAddButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "할 일 등록", message: nil, preferredStyle: .alert) /*UIAlertController를 이용하여 alert이라는 Alert을 생성*/
        let registerButton = UIAlertAction(title: "등록", style: .default, handler: { [weak self] _ in
            /*UIAlertAction을 이용하여 등록버튼 생성,
             handler에는 버튼을 눌렀을때의 행동을 클로저로 전달, 선택한 작업개체를 유일한 매개변수로 사용*/
            guard let title = alert.textFields?[0].text else { return } // textFields의 txet값이 옵셔널값이기 때문에 옵셔널 바인딩
            let task = Task(title: title, done: false) // task라는 상수를 만들고 입력한 tltle값의 할일 저장
            self?.tasks.append(task) // 할일을 저장한 task상수를 tasks 배열에 append
            self?.TableView.reloadData() // 데이터를 리로드해서 새로운 데이터를 업데이트
        })
        let cancelButton = UIAlertAction(title: "취소", style: .default, handler: nil) // 취소버튼 생성
        alert.addAction(cancelButton)//생성한 alert객체에 addAction을 이용하여 만들어둔 버튼 추가
        alert.addAction(registerButton)//생성한 alert객체에 addAction을 이용하여 만들어둔 버튼 추가
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "할 일을 입력해주세요"
        })
        self.present(alert, animated: true, completion: nil)//present로 alert 화면 출력
    }
    
    func saveTasks() { // 할일 목록 데이터 저장
        let data = self.tasks.map { // map함수를 이용하여 tasks의 원소를 data 딕셔너리에 맵핑
            [//클로저 축약
                "title": $0.title, //축약 인자 사용
                "done": $0.done
            ]
        }
        let userDefaults = UserDefaults.standard // userDefaults에 접근, userDefaults는 싱글톤 인스턴스
        //싱글톤이란 하나의 객체만 만들어놓고 여기저기서 이하나의 객체에만 접근할수있도록한다.
        userDefaults.set(data, forKey: "tasks")//"tasks"라는 이름으로 data저장
    }
    
    func loadTasks() { // 데이터 불러오기
        let userDefaults = UserDefaults.standard // 마찬가지로 userDefaults에 접근
        guard let data = userDefaults.object(forKey: "tasks") as? [[String: Any]] else { return }
        //object메서드는 반환형이 Any이기때문에 딕셔너리 타입으로 타입 캐스팅 또한 타입캐스팅을 실패하면 nil이 될수있기때문에 guard let으로 옵셔널바인딩
        self.tasks = data.compactMap { // Task구조체의 배열형태로 다시한번 맵핑
            guard let title = $0["title"] as? String else { return nil } // Key "title"의 Value를 title에 String타입으로 옵셔널바인딩
            guard let done = $0["done"] as? Bool else { return nil }
            // Key "done"의 Value를 done에 Bool타입으로 옵셔널바인딩
            return Task(title: title, done: done)//Task구조체 형태로 반환
        }
    }
}

extension ViewController: UITableViewDataSource {
    // UITableViewDataSource프로토콜의 꼭필요한 메서드 2개를 extension을 통해 구현
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count // 할일 배열의 갯수만큼 tableView의 행의 갯수 반환
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //cell에 대한 정보를 넣어 cell을 반환하는 메서드
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let task = self.tasks[indexPath.row] // 행의 순서의 대응하는 할일을 task에 저장
        cell.textLabel?.text = task.title //cell의 textLabel을 행의 순서의 대응하는 할일의 title로 저장
        if task.done {
            cell.accessoryType = .checkmark // done이 ture라면 악세서리뷰에 체크마크표시
        } else {
            cell.accessoryType = .none // 아니라면 취소
        }
        return cell // 메서드가 한번 호출될때 cell 1개를 그림
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) { //특정위치의 행을 삭제 또는 추가 요청하는 메서드
        self.tasks.remove(at: indexPath.row)// 선택한 위치의 순서에있는 tasks배열의 원소를 삭제
        tableView.deleteRows(at: [indexPath], with: .automatic)// 선택한 위치의 셀도 삭제
        
        if self.tasks.isEmpty { // 할일 목록이 비었다면
            self.doneButtonTap() // doneButtonTap()메서드 호출
        }
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) { // 특정 위치의 행을 다른 위치로 옮기는 메서드, 재정렬하는 메서드
        var tasks = self.tasks
        let task = tasks[sourceIndexPath.row] // 처음 위치의 순서에 있는 할일을 따로 저장
        tasks.remove(at: sourceIndexPath.row) // 처음 위치의 순서에 있는 할일 배열을 삭제
        tasks.insert(task, at: destinationIndexPath.row) // 바뀐 위치에 처음 위치의 있던 할일 삽입
        self.tasks = tasks // 재정렬된 배열을 다시 저장
    }
}

extension ViewController: UITableViewDelegate { // 테이블뷰의 외관과 동작을 담당하는 UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {//어떤Cell이 선택되었는지 알려주는메서드
        var task = self.tasks[indexPath.row] // 선택된 cell의 순서에있는 tasks배열의 요소를 task변수에 저장
        task.done = !task.done //task변수의 done값을 반대로 저장
        self.tasks[indexPath.row] = task // done값을 반대로 저장한 task를 덮어쓰기
        self.TableView.reloadRows(at: [indexPath], with: .automatic) // 선택된 cell만 리로드
    }
}
