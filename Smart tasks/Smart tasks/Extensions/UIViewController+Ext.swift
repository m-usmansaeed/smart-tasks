//
//  UIViewController+Ext.swift
//  Smart tasks
//
//  Created by Usman Saeed on 06/06/2024.
//

import UIKit

extension UIViewController {
        
    func setButtonWithImage(image: UIImage?, selector: Selector, isRight: Bool) {
        
        let button: UIButton = UIButton(type: .custom)
        button.contentMode = .scaleAspectFit
        button.setImage(image, for: .normal)
        button.tintColor = .white

        button.addTarget(self, action: selector, for: .touchUpInside)
        let barButtonItem: UIBarButtonItem = UIBarButtonItem(customView: button)
        
        if isRight {
            self.navigationItem.rightBarButtonItem = barButtonItem
        } else {
            self.navigationItem.leftBarButtonItem = barButtonItem
        }
    }
}
