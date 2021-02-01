//
//  PriceLabelSetuper.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import UIKit

protocol IPriceLabelSetuper {
    static func makePriceLabels(foodPrice: Double, newFoodPrice: Double,
                                completion: (_ priceLabelColor: UIColor,
                                             _ priceLabelText: String,
                                             _ newPriceLabelText: NSMutableAttributedString) -> Void)
}

final class PriceLabelSetuper: IPriceLabelSetuper {
    /// Используется для преобразования двух цен в необходимое отображение.
    ///
    /// Если foodPrice == newFoodPrice, то priceLabelText - текст цены товара черного цвета
    ///
    /// Если newFoodPrice  < foodPrice,то priceLabelText - перечеркнутый текст черного цвета, а
    /// newPriceLabelText - красный текст с действующей ценой
    /// - parameter foodPrice: Изначальная цена продукта
    /// - parameter newFoodPrice: Скидочная цена продукта
    /// - parameter completion: Возвращает строку priceLabelText цвета priceLabelColor для priceLabel-а и строку newPriceLabelText для newPriceLabelText
    static func makePriceLabels(foodPrice: Double, newFoodPrice: Double,
                                completion: (_ priceLabelColor: UIColor,
                                             _ priceLabelText: String,
                                             _ newPriceLabelText: NSMutableAttributedString) -> Void) {
        if (foodPrice == newFoodPrice) {
            let priceLabelText = "\(foodPrice) ₽"
            let newPriceLabelText  = NSMutableAttributedString(string: "")
            completion(UIColor.black, priceLabelText, newPriceLabelText)
        } else {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(foodPrice)₽")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            let priceLabelText = "\(newFoodPrice) ₽"
            let newPriceLabelText = attributeString
            completion(UIColor.red, priceLabelText, newPriceLabelText )
        }
    }
}
