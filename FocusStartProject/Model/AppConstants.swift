//
//  AppConstants.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/11/20.
//

import UIKit

enum AppConstants {
    static let screenHeight: CGFloat = UIScreen.main.bounds.height

    enum NotificationNames {
        static let refreshProfileTableView = "refreshTableViewAfterNewOrders"
    }

    enum Constraints {
        static let normalAnchorConstant: CGFloat = 16
    }

    enum Sizes {
        static let likeButtonSize: CGSize = CGSize(width: 35, height: 35)
    }

    enum Images {
        static let like = UIImage(systemName: "heart")
        static let likeFilled = UIImage(systemName: "heart.fill")
    }

}
