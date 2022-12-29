//
//  ViewController.swift
//  ToDoListVerK
//
//  Created by 강지원 on 2022/06/13.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var editButton: UIBarButtonItem!
    var doneButton: UIBarButtonItem!
    var tasks: [Task] = [] {
        didSet {
            saveTask()
        }
    }
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapDonebutton))
        loadTask()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    @objc func tapDonebutton() {
        self.navigationItem.leftBarButtonItem = self.editButton
        self.tableView.setEditing(false, animated: true)
    }

    @IBAction func tapEditButton(_ sender: UIBarButtonItem) {
        guard !self.tasks.isEmpty else { return }
        self.navigationItem.leftBarButtonItem = self.doneButton
        self.tableView.setEditing(true, animated: true)
    }
    
    @IBAction func tapAddButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "할 일 등록", message: nil, preferredStyle: .alert)
        let registButton = UIAlertAction(title: "등록", style: .default) { _ in
            guard let title = alert.textFields?[0].text else { return }
            let task = Task(title: title, done: false)
            self.tasks.append(task)
            self.tableView.reloadData()
        }
        let cancleButton = UIAlertAction(title: "취소", style: .default, handler: nil)
        alert.addAction(registButton)
        alert.addAction(cancleButton)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "할일을 등록해주세요."
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveTask() {
        let data = self.tasks.map {
            [
                "title" : $0.title,
                "done" : $0.done
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "tasks")
    }
    
    func loadTask() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "tasks") as? [[String : Any]] else { return }
        self.tasks = data.compactMap { // 자동으로 nil을 제거하고 옵셔널 바인딩을 하는 compactMap() 사용
            guard let title = $0["title"] as? String else { return nil} //타입캐스팅을 했기때문에 옵셔널값이고 옵셔널바인딩
            guard let done = $0["done"] as? Bool else { return nil}
            return Task(title: title, done: done)
        }
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) //그려야되는cell의 위치정보
        let task = self.tasks[indexPath.row]
        cell.textLabel?.text = task.title
        if task.done {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.tasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        if self.tasks.isEmpty {
            tapDonebutton()
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let task = self.tasks[sourceIndexPath.row]
        self.tasks.remove(at: sourceIndexPath.row)
        self.tasks.insert(task, at: destinationIndexPath.row)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var task = self.tasks[indexPath.row]
        task.done = !task.done
        self.tasks[indexPath.row] = task
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
