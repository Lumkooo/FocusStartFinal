//
//  String-ApplyPatternOnNumbers.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/10/20.
//

import Foundation

extension String {
    /// Перевод строки в формат времени XX-XX. Также можно использовать для обратного преобразования
    func applyPatternOnNumbers(pattern: String, replacmentCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: self)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
}
