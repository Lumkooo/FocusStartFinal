//
//  MainScreenPlacesCollectionViewDelegate.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import UIKit

protocol IMainScreenPlacesDelegate: class {
    func selectedCell(collectionView: UICollectionView, indexPath: IndexPath)
}

final class MainScreenPlacesCollectionViewDelegate: NSObject {

    // MARK: - Constants

    private enum Constants {
        static let collectionViewCellHeight: CGFloat = UIScreen.main.bounds.height * 0.28
        static let collectionViewCellWidth: CGFloat = UIScreen.main.bounds.width - 50
        static let cellSpacing: CGFloat = 24
    }

    weak var delegate: IMainScreenPlacesDelegate?

    // MARK: - Init

    init(withDelegate delegate: IMainScreenPlacesDelegate) {
        self.delegate = delegate
    }
}

// MARK: - UICollectionViewDelegate

extension MainScreenPlacesCollectionViewDelegate: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.selectedCell(collectionView: collectionView, indexPath: indexPath)
    }
}

extension MainScreenPlacesCollectionViewDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.collectionViewCellWidth,
                      height: Constants.collectionViewCellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Constants.cellSpacing
    }
}
