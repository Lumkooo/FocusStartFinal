//
//  String-StringProtocol.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/18/20.
//

import Foundation

// Для доступа к элементам String-а следующимо образом  someString[i].
//Используется в анимированном загрзочном экране
extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }

    subscript(range: Range<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }

    subscript(range: ClosedRange<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }

    subscript(range: PartialRangeFrom<Int>) -> SubSequence {
        self[index(startIndex, offsetBy: range.lowerBound)...]
    }

    subscript(range: PartialRangeThrough<Int>) -> SubSequence {
        self[...index(startIndex, offsetBy: range.upperBound)]
    }

    subscript(range: PartialRangeUpTo<Int>) -> SubSequence {
        self[..<index(startIndex, offsetBy: range.upperBound)]
    }
}
