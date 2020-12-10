//
//  MenuScreenCollectionViewDelegate.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import UIKit

protocol IMenuScreenPlacesDelegate: class {
    func selectedCell(indexPath: IndexPath)
}

final class MenuScreenCollectionViewDelegate: NSObject {

    // MARK: - Constants

    private enum Constants {
        static let collectionViewCellHeight: CGFloat = UIScreen.main.bounds.height / 4
        static let collectionViewCellWidth: CGFloat = UIScreen.main.bounds.width / 2 - Constants.cellSpacing
        static let cellSpacing: CGFloat = 24
    }

    // MARK: - Properties

    weak var delegate: IMenuScreenPlacesDelegate?

    // MARK: - Init

    init(withDelegate delegate: IMenuScreenPlacesDelegate) {
        self.delegate = delegate
    }
}

// MARK: - UITableViewDelegate

extension MenuScreenCollectionViewDelegate: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.selectedCell(indexPath: indexPath)
    }
}

extension MenuScreenCollectionViewDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.collectionViewCellWidth,
                      height: Constants.collectionViewCellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Constants.cellSpacing
    }

}
