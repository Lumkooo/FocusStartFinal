//
//  TimeManager.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/9/20.
//

import Foundation

final class TimeManager {
    /// isForUser == true значит, что возвращенное время будет использовано для списка истории заказов в профиле пользователя
    /// isForUser == false значит, что время будет использовано для отправления заказа ресторанам
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
    
    private func makeMoreRealistic(digit: Int) -> String{
        if digit < 10 {
            return "0\(digit)"      //Для обозначения минут не как, например 14 часов 1 минута, а как
        } else {                              // 14 часов 01 минута. 14:01 выглядит привычнее, чем 14:1
            return "\(digit)"
        }
    }
    
    private func monthIntToString(forMonth month:Int) -> String{
        // Можно было бы и exntension Int сделать, но почему бы и не так
        // Используется для отслеживания даты заказа
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
