//
//  TimeManager.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/9/20.
//

import Foundation

final class TimeManager {
    /// Возвращает текущее время
    /// - parameter isForUser: true возвращает время вида hour : minutes day month. false возвращает время вида hour : minutes : seconds:nanoseconds day month
    func getCurrentTime(isForUser: Bool) -> String {
        var timeString = ""
        let hour = Calendar.current.component(.hour, from: Date())
        let intMinutes = Calendar.current.component(.minute, from: Date())
        let intSeconds = Calendar.current.component(.second, from: Date())
        let nanoseconds = Calendar.current.component(.nanosecond, from: Date())
        let day = Calendar.current.component(.day, from: Date())
        let month = monthIntToString(forMonth: Calendar.current.component(.month, from: Date()))
        var minutes:String = ""
        var seconds:String = ""
        seconds = makeMoreRealistic(digit: intSeconds)
        minutes = makeMoreRealistic(digit: intMinutes)
        if isForUser {
            timeString = "\("\(hour):\(minutes) \(day) \(month)")"
        } else {
            timeString = "\("\(hour):\(minutes):\(seconds):\(nanoseconds) \(day) \(month)")"
        }
        return timeString
    }

    /// Для более привычного обозначения минут
    ///
    /// Например, не как 14 часов 1 минута, а как
    /// 14 часов 01 минута. 14:01 выглядит привычнее, чем 14:1
    private func makeMoreRealistic(digit: Int) -> String{
        if digit < 10 {
            return "0\(digit)"
        } else {
            return "\(digit)"
        }
    }

    /// Преобразование числа месяца в строку месяца
    private func monthIntToString(forMonth month:Int) -> String {
        switch month {
        case 1:
            return "Января"
        case 2:
            return "Февраля"
        case 3:
            return "Марта"
        case 4:
            return "Апреля"
        case 5:
            return "Мая"
        case 6:
            return "Июня"
        case 7:
            return "Июля"
        case 8:
            return "Августа"
        case 9:
            return "Сентября"
        case 10:
            return "Октября"
        case 11:
            return "Ноября"
        default:
            return "Декабря"
        }
    }
}
