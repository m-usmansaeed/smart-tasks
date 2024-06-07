//
//  TaskStatusActionsCell.swift
//  Smart tasks
//
//  Created by Usman Saeed on 06/06/2024.
//

import UIKit

protocol TaskStatusDelegate: AnyObject {
    func didTapResolveTask()
    func didCantResolveTask()
}

class TaskStatusActionsCell: UITableViewCell {
    @IBOutlet weak var btnResolveTask: UIButton!
    @IBOutlet weak var btncantResolveTask: UIButton!
    weak var delegate: TaskStatusDelegate?
    
    func configureCell() {
        self.btnResolveTask.layer.cornerRadius = 5
        self.btnResolveTask.layer.masksToBounds = true

        self.btncantResolveTask.layer.cornerRadius = 5
        self.btncantResolveTask.layer.masksToBounds = true
    }
    
    @IBAction func btnResolveTask(_ sender: Any) {
        self.delegate?.didTapResolveTask()
    }
    
    @IBAction func btnCantResolveTask(_ sender: Any) {
        self.delegate?.didCantResolveTask()
    }
}
