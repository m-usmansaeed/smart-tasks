//
//  TaskTVCell.swift
//  Smart tasks
//
//  Created by Usman Saeed on 06/06/2024.
//

import UIKit

class TaskTVCell: UITableViewCell {

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var lblTaskTitle: UILabel!
    @IBOutlet weak var lblDueDate: UILabel!
    @IBOutlet weak var lblDaysLeft: UILabel!
    @IBOutlet weak var priorityBadge: UIView!
    
    var task: STTask?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.lblTaskTitle.text = nil
        self.lblDueDate.text = nil
        self.lblDaysLeft.text = nil
        self.priorityBadge.backgroundColor = .white
    }
    
    func configureCell() {
        self.container.layer.cornerRadius = 5
        self.container.layer.masksToBounds = true
        self.priorityBadge.layer.cornerRadius = 7.5
        self.priorityBadge.layer.masksToBounds = true

        if let task {
            self.lblTaskTitle.text = task.title
            
            if let dueDate = task.dueDate {
                self.lblDueDate.text = formattedDateString(from: dueDate)
            }
            
            let color = getColorForPriority(priority: task.priority)
            self.priorityBadge.backgroundColor = color
            
            if let dueDate = task.dueDate {
                self.lblDaysLeft.text = "\(daysBetweenDates(dueDate: dueDate).unwrapped(defaultV: 0))"
            }
            
        }
    }
    
}
