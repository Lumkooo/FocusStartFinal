//
//  AppConstants.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/11/20.
//

import UIKit

enum AppConstants {
    static let screenHeight: CGFloat = UIScreen.main.bounds.height
    static let screenWidth: CGFloat = UIScreen.main.bounds.width

    // MARK: - NotificationNames

    enum NotificationNames {
        static let refreshProfileTableView = "refreshTableViewAfterNewOrders"
    }

    // MARK: - Constraints

    enum Constraints {
        static let quarterNormalAnchorConstaint: CGFloat = 4
        static let halfNormalAnchorConstaint: CGFloat = 8
        static let normalAnchorConstant: CGFloat = 16
        static let twiceNormalAnchorConstant: CGFloat = 32
        static let collectionViewCellSpacing: CGFloat = 24
    }

    // MARK: - Sizes

    enum Sizes {
        static let likeButtonSize: CGSize = CGSize(width: 35, height: 35)
        static let closeViewButtonSize: CGSize = CGSize(width: 30, height: 30)
        static let userLocationButtonSize: CGSize = CGSize(width: 32, height: 32)
        static let mainScreenCollectionViewHeight: CGFloat = UIScreen.main.bounds.height * 0.27 + 30
        static let cornerRadius: CGFloat = 15
        static let borderWidth: CGFloat = 5
        static let shadowRadius: CGFloat = 6
        static let shadowOpacity: Float = 1
        static let buttonsHeight: CGFloat = 50
        static let estimatedTableViewHeight: CGFloat = 80
    }

    // MARK: - CollectionViewSize

    enum CollectionViewSize {
        static let menuScreenCollectionViewCell: CGSize = CGSize(
            width: AppConstants.screenWidth / 2 - AppConstants.Constraints.collectionViewCellSpacing,
            height: AppConstants.screenHeight / 4)
        static let mainScreenCollectionViewCellSize = CGSize(
            width: AppConstants.screenWidth - 50,
            height: AppConstants.screenHeight * 0.28)
    }

    // MARK: - Images

    enum Images {
        static let like = UIImage(systemName: "heart")
        static let likeFilled = UIImage(systemName: "heart.fill")
        static let searchImage = UIImage(systemName: "magnifyingglass")
        static let userLocationButtonImage = UIImage(systemName: "location")
        static let userLocationButtonImageFilled = UIImage(systemName: "location.fill")
        static let hidePasswordImage = UIImage(systemName: "eye.fill")
        static let showPasswordImage = UIImage(systemName: "eye.slash.fill")
        static let emailImage = UIImage(named: "emailImage")
    }

    // MARK: - TableViewCellIdentifiers

    enum TableViewCellIdentifiers {
        static let searchingTableViewCellID = "searchingTableViewCellID"
    }

    // MARK: - AnimtaionTime

    enum AnimationTime {
        static let keyboardAnimationDuration: Double = 0.25
    }

}
