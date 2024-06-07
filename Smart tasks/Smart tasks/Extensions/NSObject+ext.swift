//
//  NSObject+ext.swift
//  Smart tasks
//
//  Created by Usman Saeed on 06/06/2024.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
