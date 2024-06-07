//
//  TaskListViewController.swift
//  Smart tasks
//
//  Created by Usman Saeed on 06/06/2024.
//

import UIKit

class TaskListViewController: UIViewController {
    @IBOutlet var emptyView: UIView!
    @IBOutlet weak var tableview: UITableView!
    
    var taskList: [STTask] = []
    
    var startOfDay : Date = Date()
    var endOfDay : Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let calendar = Calendar.current
        let now = Date()
        startOfDay = calendar.startOfDay(for: now)
        
        self.setupUI()
        self.fetchTaskFromServer()

    }
    
    func setupUI() {
        
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.register(
            UINib(nibName: TaskTVCell.className, bundle: nil),
            forCellReuseIdentifier: TaskTVCell.className
        )
        
        let boldConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        self.setButtonWithImage(
            image: UIImage(systemName: "chevron.left", withConfiguration: boldConfig),
            selector: #selector(leftButtonClicked),
            isRight: false)
        
        self.setButtonWithImage(
            image: UIImage(systemName: "chevron.right", withConfiguration: boldConfig),
            selector: #selector(leftRightButtonClicked),
            isRight: true)
    }
    
    func updateTitle() {
        self.title = formattedDateString(from: startOfDay)
    }
    
    @objc func leftButtonClicked() {
        let calendar = Calendar.current
        if let startOfDay = calendar.date(byAdding: .day, value: -1, to: startOfDay)?.addingTimeInterval(-1) {
            self.startOfDay = startOfDay
        }
        taskFromDatabase()
        updateTitle()
    }
    
    @objc func leftRightButtonClicked() {
        startOfDay = endOfDay
        taskFromDatabase()
        updateTitle()
    }
    
    func taskFromDatabase() {
        
        let calendar = Calendar.current
        if let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)?.addingTimeInterval(-1) {
            self.endOfDay = endOfDay
        }
        
        if let tasks = fetchTasks(startOfDay: startOfDay, endOfDay: endOfDay) {
            
            if tasks.count == 0 {
                self.tableview.backgroundView = emptyView
            } else {
                self.tableview.backgroundView = nil
            }
            
            self.prepareData(tasks)
        }
        
    }
    
    func fetchTaskFromServer() {
        STTaskService.shared.getTaskList { [weak self] _ in
            DispatchQueue.main.async {
                self?.taskFromDatabase()
            }
        } _: { error in
            print(error)
            self.taskFromDatabase()
        }
    }
    
    func prepareData(_ tasks: [STTask]) {
        PersistentStorage.shared.saveContext()
        let predicates: [TaskSortOrder] = [
            { $0.priority > $1.priority}
//            { $0.dueDate.unwrapped(defaultV: Date()) < $1.dueDate.unwrapped(defaultV: Date()) }
        ]
        
        self.taskList = sortTask(array: tasks, predicates: predicates)
        self.tableview.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TaskDetailViewController,
            let task = sender as? STTask {
            vc.task = task
        }
    }
    
}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTVCell.className, for: indexPath) as? TaskTVCell else { return UITableViewCell() }
        cell.task = self.taskList[indexPath.row]
        cell.configureCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = self.taskList[indexPath.row]
        self.performSegue(withIdentifier: "showDetails", sender: task)
    }
    
}
