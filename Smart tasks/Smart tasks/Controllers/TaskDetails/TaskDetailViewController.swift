//
//  TaskDetailViewController.swift
//  Smart tasks
//
//  Created by Usman Saeed on 06/06/2024.
//

import UIKit
import CoreData

class TaskDetailViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    var task: STTask?
    var comments: [STComment] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.fetchComments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Task Detail"
    }
    
    func setupUI() {
        
        let boldConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        self.setButtonWithImage(
            image: UIImage(systemName: "chevron.left", withConfiguration: boldConfig),
            selector: #selector(leftButtonClicked),
            isRight: false)
        
        tableview.register(
            UINib(nibName: DetailCell.className, bundle: nil),
            forCellReuseIdentifier: DetailCell.className
        )
        tableview.register(
            UINib(nibName: TaskStatusActionsCell.className, bundle: nil),
            forCellReuseIdentifier: TaskStatusActionsCell.className
        )
        tableview.register(
            UINib(nibName: CommentCell.className, bundle: nil),
            forCellReuseIdentifier: CommentCell.className
        )
        tableview.register(
            UINib(nibName: TaskStatueTVCell.className, bundle: nil),
            forCellReuseIdentifier: TaskStatueTVCell.className
        )
    }
    
    @objc func leftButtonClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func fetchComments() {
        
        if let task = self.task,
            let taskId = task.id,
            let _comments = fetchCommentsForTask(with: taskId) {
            let predicates: [CommentSortOrder] = [
                { $0.date.unwrapped(defaultV: Date()) < $1.date.unwrapped(defaultV: Date())}
            ]
            let sorted = sortComments(array: _comments, predicates: predicates)
            self.comments = sorted
            self.tableview.reloadData()
        }
    }
    
    func saveComment(username: String, userComment: String) {
        
        guard let entity = NSEntityDescription.entity(forEntityName: "STComment", in: PersistentStorage.shared.context) else {
            fatalError("Failed to decode STComment entity.")
        }
        let comment = STComment(entity: entity, insertInto: PersistentStorage.shared.context)
        comment.id = UUID().uuidString
        comment.username = username
        comment.comment = userComment
        comment.date = Date()
        
        if let taskid = self.task?.id {
            comment.taskid = taskid
        }

        PersistentStorage.shared.saveContext()
        self.fetchComments()
    }
    
    @objc func showAlert() {
        let alertController = UIAlertController(title: nil, message: "Please fill the required fields.", preferredStyle: .alert)
        
        // Add text fields
        alertController.addTextField { textField in
            textField.placeholder = "Enter your name"
            textField.tag = 1 // You can use tags to identify the text fields later
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Enter your comment"
            textField.keyboardType = .emailAddress
            textField.tag = 2
        }
        
        // Add actions
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let textFields = alertController.textFields else { return }
            
            // Retrieve text from text fields
            let name = textFields[0].text ?? ""
            let comment = textFields[1].text ?? ""
            
            self?.handleUserInput(name: name, comment: comment)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        // Present the alert
        present(alertController, animated: true, completion: nil)
    }
    
    private func handleUserInput(name: String, comment: String) {
        if name != "" && comment != "" {
            self.saveComment(username: name, userComment: comment)
        }
    }
    
    
}

extension TaskDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 2 + self.comments.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: DetailCell.className,
                for: indexPath
            ) as! DetailCell
            
            cell.task = task
            cell.delegate = self
            cell.configureCell()
            return cell
            
        } else {
                        
            if self.comments.count > 0 {
                
                if indexPath.row == self.comments.count + 1 {
                    
                    if let task = self.task,
                        let status = task.status {
                        
                        if status == TaskStatus.unresolved.rawValue {
                            
                            let cell = tableView.dequeueReusableCell(
                                withIdentifier: TaskStatusActionsCell.className,
                                for: indexPath
                            ) as! TaskStatusActionsCell
                            
                            cell.configureCell()
                            cell.delegate = self
                            return cell
                            
                        } else {
                            
                            let cell = tableView.dequeueReusableCell(
                                withIdentifier: TaskStatueTVCell.className,
                                for: indexPath
                            ) as! TaskStatueTVCell
                            
                            cell.status = status
                            cell.configureCell()
                            return cell
                            
                        }
                        
                    } else {
                        return UITableViewCell()
                    }
                    
                }
                else {
                    
                    
                    let cell = tableView.dequeueReusableCell(
                        withIdentifier: CommentCell.className,
                        for: indexPath
                    ) as! CommentCell
                    
                    cell.comment = comments[indexPath.row - 1]
                    cell.configureCell()
                    return cell
                }
                
            } else {
                
                if let task = self.task, 
                    let status = task.status {
                    
                    if status == TaskStatus.unresolved.rawValue {
                        
                        let cell = tableView.dequeueReusableCell(
                            withIdentifier: TaskStatusActionsCell.className,
                            for: indexPath
                        ) as! TaskStatusActionsCell
                        
                        cell.configureCell()
                        cell.delegate = self
                        return cell
                        
                    } else {
                        
                        let cell = tableView.dequeueReusableCell(
                            withIdentifier: TaskStatueTVCell.className,
                            for: indexPath
                        ) as! TaskStatueTVCell
                        
                        cell.status = status
                        cell.configureCell()
                        return cell
                        
                    }
                    
                } else {
                    return UITableViewCell()
                }
            }
        }
    }
    
}

extension TaskDetailViewController: TaskStatusDelegate {
    
    func didTapResolveTask() {
        if let task = self.task, let taskId = task.id {
            updateTaskStatus(taskId: taskId, newPriority: TaskStatus.resolved.rawValue)
            self.task?.status = TaskStatus.resolved.rawValue
            self.tableview.reloadData()
        }
    }
    
    func didCantResolveTask() {
        if let task = self.task, let taskId = task.id {
            updateTaskStatus(taskId: taskId, newPriority: TaskStatus.cantResolve.rawValue)
            self.task?.status = TaskStatus.cantResolve.rawValue
            self.tableview.reloadData()
        }
    }
    
}

extension TaskDetailViewController : DetailCellDelegate {
    func didTapAddComment() {
        
        let alert = UIAlertController(title: "Do you want to left comment?", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.showAlert()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ in }))
        self.present(alert, animated: true)
        
    }
}
