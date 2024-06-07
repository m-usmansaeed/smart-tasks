//
//  CommentCell.swift
//  Smart tasks
//
//  Created by Usman Saeed on 06/06/2024.
//

import UIKit

class CommentCell: UITableViewCell {
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var lblDate: UILabel!

    var comment: STComment?
    
    func configureCell() {
        self.container.layer.cornerRadius = 5
        self.container.layer.masksToBounds = true

        if let comment {
            self.lblUsername.text = comment.username
            self.lblComment.text = comment.comment
            if let date = comment.date {
                self.lblDate.text = formattedDateString(from: date)
            }
        }
    }
    
}
