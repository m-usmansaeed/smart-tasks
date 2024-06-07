//
//  Optional+ext.swift
//  Smart tasks
//
//  Created by Usman Saeed on 06/06/2024.
//

import Foundation

extension Optional {
    func unwrapped<T>(defaultV:T) -> T {
        switch self {
        case .some(let value):
            return value as? T ?? defaultV
        case _:
            return defaultV
        }
    }
}
