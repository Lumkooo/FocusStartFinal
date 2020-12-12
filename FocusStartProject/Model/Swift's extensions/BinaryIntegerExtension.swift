//
//  BinaryIntegerExtension.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/11/20.
//

import Foundation

extension BinaryInteger {
    var digits: [Int] {
        return String(describing: self).compactMap { Int(String($0)) }
    }
}
