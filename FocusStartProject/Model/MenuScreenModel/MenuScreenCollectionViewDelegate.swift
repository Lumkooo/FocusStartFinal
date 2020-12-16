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

    // MARK: - Properties

    private weak var delegate: IMenuScreenPlacesDelegate?

    // MARK: - Init

    init(withDelegate delegate: IMenuScreenPlacesDelegate) {
        self.delegate = delegate
    }
}

// MARK: - UICollectionViewDelegate

extension MenuScreenCollectionViewDelegate: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        delegate?.selectedCell(indexPath: indexPath)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MenuScreenCollectionViewDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: AppConstants.CollectionViewSize.menuScreenCollectionViewCell.width,
                      height: AppConstants.CollectionViewSize.menuScreenCollectionViewCell.height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        AppConstants.Constraints.collectionViewCellSpacing
    }
}
