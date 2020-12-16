//
//  BinaryIntegerExtension.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/11/20.
//

import Foundation

extension BinaryInteger {
    /// Разделение числа на составляющие его числа, возвращаемых как массив
    ///
    /// 123 -> [1,2,3]
    var digits: [Int] {
        return String(describing: self).compactMap { Int(String($0)) }
    }
}
