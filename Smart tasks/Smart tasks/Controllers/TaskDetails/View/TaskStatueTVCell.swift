//
//  TaskStatueTVCell.swift
//  Smart tasks
//
//  Created by Usman Saeed on 06/06/2024.
//

import UIKit

class TaskStatueTVCell: UITableViewCell {

    @IBOutlet weak var imgViewStatus: UIImageView!
    var status: String?
    
    func configureCell() {
        if let status = status {
            if status == TaskStatus.resolved.rawValue {
                self.imgViewStatus.image = UIImage(named: "resolved_sign")
            } else {
                self.imgViewStatus.image = UIImage(named: "unresolved_sign")
            }
        }
    }
    
}
