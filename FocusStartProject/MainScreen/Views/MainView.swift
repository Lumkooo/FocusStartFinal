//
//  MainView.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import UIKit

protocol IMainView: class {
    var cellSelectedWithPlace: ((IndexPath) -> Void)? { get set }
    func setupPlacesCollectionView(places: [Place])
}

final class MainView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let anchorConstant:CGFloat = 16
        static let collectionViewHeight:CGFloat = UIScreen.main.bounds.height * 0.27 + 30
        static let collectionViewSectionInset: CGFloat = 16
    }

    // MARK: - Views

    private let nearestPlacesLabel: UILabel={
        let myLabel = UILabel()
        myLabel.text = "Ближайшие места:"
        myLabel.font = AppFonts.largeTitleLabelFont
        return myLabel
    }()

    private let placesCollectionView: UICollectionView={
        let myCollectionView:UICollectionView = UICollectionView(frame: CGRect.zero,
                                                                 collectionViewLayout: UICollectionViewFlowLayout.init())
        myCollectionView.register(MainScreenCollectionViewCell.self,
                                  forCellWithReuseIdentifier: MainScreenCollectionViewCell.reuseIdentifier)
        return myCollectionView
    }()

    // MARK: - Properties
    private var collectionViewPlacesDataSource = MainScreenPlacesCollectionViewDataSource()
    private var collectionViewPlacesDelegate: MainScreenPlacesCollectionViewDelegate?
    var cellSelectedWithPlace: ((IndexPath) -> Void)?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        self.setupElements()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Установка constraint-ов для элементов

private extension MainView {
    func setupElements() {
        self.setupNearestPlacesLabel()
        self.setupPlacesCollectionView()
    }

    func setupNearestPlacesLabel() {
        self.addSubview(self.nearestPlacesLabel)
        self.nearestPlacesLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.nearestPlacesLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: Constants.anchorConstant),
            self.nearestPlacesLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Constants.collectionViewSectionInset)
        ])
    }

    func setupPlacesCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0,
                                           left: Constants.collectionViewSectionInset,
                                           bottom: 0,
                                           right: Constants.collectionViewSectionInset)
        self.placesCollectionView.setCollectionViewLayout(layout, animated: true)
        self.collectionViewPlacesDelegate = MainScreenPlacesCollectionViewDelegate(withDelegate: self)
        self.placesCollectionView.delegate = self.collectionViewPlacesDelegate
        self.placesCollectionView.dataSource = self.collectionViewPlacesDataSource
        self.placesCollectionView.backgroundColor = UIColor.clear
        self.addSubview(self.placesCollectionView)
        self.placesCollectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.placesCollectionView.topAnchor.constraint(equalTo: self.nearestPlacesLabel.bottomAnchor, constant: Constants.anchorConstant),
            self.placesCollectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            self.placesCollectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            self.placesCollectionView.heightAnchor.constraint(equalToConstant: Constants.collectionViewHeight)
        ])
    }
}

extension MainView: IMainView {
    func setupPlacesCollectionView(places: [Place]) {
        self.collectionViewPlacesDataSource.placesArray = places
        self.placesCollectionView.reloadData()
    }
}

extension MainView: IMainScreenPlacesDelegate {
    func selectedCell(indexPath: IndexPath) {
        self.cellSelectedWithPlace?(indexPath)
    }
}
