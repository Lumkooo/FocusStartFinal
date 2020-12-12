//
//  Fonts.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/11/20.
//

import UIKit

enum AppFonts {
    private enum Constants {
        static let mainScreenCollectionViewCellTitleFontConstant: CGFloat = 0.03
        static let menuScreenCollectionViewCellTitleFontConstant:CGFloat = 0.02
        static let menuScreenCollectionViewCellPriceFont:CGFloat = 0.018
    }

    static let largeTitleLabelFont = UIFont.systemFont(ofSize: 26, weight: .semibold)
    static let bigTitleLabelFont = UIFont.systemFont(ofSize: 22, weight: .semibold)
    static let titleLabelFont = UIFont.systemFont(ofSize: 20, weight: .light)
    static let mainScreenCollectionViewCellLabelFont = UIFont.systemFont(
        ofSize: Constants.mainScreenCollectionViewCellTitleFontConstant * AppConstants.screenHeight
        ,weight: .light)
    static let menuScreenCollectionViewCellTitleLabelFont = UIFont.systemFont(
        ofSize: Constants.menuScreenCollectionViewCellTitleFontConstant * AppConstants.screenHeight
        ,weight: .light)
    static let menuScreenCollectionViewCellPriceLabelFont = UIFont.systemFont(
        ofSize: Constants.menuScreenCollectionViewCellPriceFont * AppConstants.screenHeight
        ,weight: .light)
}
