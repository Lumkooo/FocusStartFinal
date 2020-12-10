//
//  MenuView.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/8/20.
//

import UIKit

protocol IMenuView: class {
    var cellTapped: ((IndexPath) -> Void)? { get set }

    func setupCollectionView(withFoodArray foodArray: [Food])
}

final class MenuView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let anchorConstant:CGFloat = 16
        static let collectionViewHeight:CGFloat = UIScreen.main.bounds.height/4 + 30
        static let collectionViewSectionInset: CGFloat = 16
        static let collectionViewSectionTopInset: CGFloat = 32
    }

    // MARK: - Views

    private lazy var collectionView: UICollectionView = {
        let myCollectionView:UICollectionView = UICollectionView(frame: CGRect.zero,
                                                                 collectionViewLayout: UICollectionViewFlowLayout.init())
        myCollectionView.register(MenuCollectionViewCell.self,
                                  forCellWithReuseIdentifier: MenuCollectionViewCell.reuseIdentifier)
        myCollectionView.backgroundColor = .systemBackground
        return myCollectionView
    }()

    // MARK: - Properties

    private var collectionViewDataSource = MenuScreenCollectionViewDataSource()
    private var collectionViewDelegate: MenuScreenCollectionViewDelegate?
    var cellTapped: ((IndexPath) -> Void)?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        self.setupElements()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - IMenuView

extension MenuView: IMenuView {
    func setupCollectionView(withFoodArray foodArray: [Food]) {
        self.collectionViewDataSource.foodArray = foodArray
        self.collectionView.reloadData()
    }
}

// MARK: - UISetup

private extension MenuView {
    func setupElements() {
        self.setupPlacesCollectionView()
    }

    func setupPlacesCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: Constants.collectionViewSectionTopInset,
                                           left: Constants.collectionViewSectionInset,
                                           bottom: Constants.collectionViewSectionInset,
                                           right: Constants.collectionViewSectionInset)
        self.collectionView.setCollectionViewLayout(layout, animated: true)
        self.collectionViewDelegate = MenuScreenCollectionViewDelegate(withDelegate: self)
        self.collectionView.delegate = self.collectionViewDelegate
        self.collectionView.dataSource = self.collectionViewDataSource
        self.addSubview(self.collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension MenuView: IMenuScreenPlacesDelegate {
    func selectedCell(indexPath: IndexPath) {
        cellTapped?(indexPath)
    }
}
