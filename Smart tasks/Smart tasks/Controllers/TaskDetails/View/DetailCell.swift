//
//  DetailCell.swift
//  Smart tasks
//
//  Created by Usman Saeed on 06/06/2024.
//

import UIKit

protocol DetailCellDelegate: AnyObject {
    func didTapAddComment()
}

class DetailCell: UITableViewCell {
    
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var lblTaskTitle: UILabel!
    @IBOutlet weak var lblTaskDueDate: UILabel!
    @IBOutlet weak var lblTaskDaysLeft: UILabel!
    @IBOutlet weak var lblTaskDescription: UILabel!
    @IBOutlet weak var lblTaskStatus: UILabel!
    weak var delegate: DetailCellDelegate?
    
    var task: STTask?
    
    func configureCell() {
        self.detailView.layer.cornerRadius = 5
        self.detailView.layer.masksToBounds = true
        
        if let task {
            
            if let status = task.status {
                let color = getColorForStatus(status: status)
                self.lblTaskTitle.textColor = color
                self.lblTaskStatus.textColor = color
                self.lblTaskDueDate.textColor = color
                self.lblTaskDaysLeft.textColor = color
            }
            
            
            self.lblTaskTitle.text = task.title
            self.lblTaskDescription.text = task.taskDescription
            self.lblTaskStatus.text = task.status
            
            if let dueDate = task.dueDate {
                self.lblTaskDueDate.text = formattedDateString(from: dueDate)
                self.lblTaskDaysLeft.text = "\(daysBetweenDates(dueDate: dueDate).unwrapped(defaultV: 0))"
            }
        }
    }
    
    @IBAction func btnAddComment(_ sender: Any) {
        self.delegate?.didTapAddComment()
    }
}
