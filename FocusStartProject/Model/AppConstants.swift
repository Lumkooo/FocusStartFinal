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
}
