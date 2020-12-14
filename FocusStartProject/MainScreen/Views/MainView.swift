//
//  MainView.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import UIKit

protocol IMainView: class {
    var nearestPlacesCellTapped: ((IndexPath) -> Void)? { get set }
    var likedPlacesCellTapped: ((IndexPath) -> Void)? { get set }

    func setupPlacesCollectionView(places: [Place])
    func setupLikedPlacesCollectionView(likedPlaces: [Place])
    func hideLikedPlacesCollectionView()
}

final class MainView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let anchorConstant:CGFloat = 8
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

    private let likedPlacesLabel: UILabel={
        let myLabel = UILabel()
        myLabel.text = "Избранные места:"
        myLabel.font = AppFonts.largeTitleLabelFont
        return myLabel
    }()

    private let likedPlacesCollectionView: UICollectionView={
        let myCollectionView:UICollectionView = UICollectionView(frame: CGRect.zero,
                                                                 collectionViewLayout: UICollectionViewFlowLayout.init())
        myCollectionView.register(MainScreenCollectionViewCell.self,
                                  forCellWithReuseIdentifier: MainScreenCollectionViewCell.reuseIdentifier)
        return myCollectionView
    }()



    // MARK: - Properties
    private var collectionViewNearestPlacesDataSource = MainScreenPlacesCollectionViewDataSource()
    private var collectionViewNearestPlacesDelegate: MainScreenPlacesCollectionViewDelegate?
    private var collectionViewLikedPlacesDataSource = MainScreenPlacesCollectionViewDataSource()
    private var collectionViewLikedPlacesDelegate: MainScreenPlacesCollectionViewDelegate?
    var nearestPlacesCellTapped: ((IndexPath) -> Void)?
    var likedPlacesCellTapped: ((IndexPath) -> Void)?

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

// MARK: - Nearest Places Constraints

private extension MainView {
    func setupElements() {
        self.setupNearestPlacesLabel()
        self.setupPlacesCollectionView()
    }

    func setupNearestPlacesLabel() {
        self.addSubview(self.nearestPlacesLabel)
        self.nearestPlacesLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.nearestPlacesLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor,
                                                         constant: Constants.anchorConstant),
            self.nearestPlacesLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                                                             constant: Constants.collectionViewSectionInset)
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
        self.collectionViewNearestPlacesDelegate = MainScreenPlacesCollectionViewDelegate(withDelegate: self)
        self.placesCollectionView.delegate = self.collectionViewNearestPlacesDelegate
        self.placesCollectionView.dataSource = self.collectionViewNearestPlacesDataSource
        self.placesCollectionView.backgroundColor = UIColor.clear
        self.addSubview(self.placesCollectionView)
        self.placesCollectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.placesCollectionView.topAnchor.constraint(equalTo: self.nearestPlacesLabel.bottomAnchor,
                                                           constant: Constants.anchorConstant),
            self.placesCollectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            self.placesCollectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            self.placesCollectionView.heightAnchor.constraint(equalToConstant: Constants.collectionViewHeight)
        ])
    }
}

// MARK: - Liked Places Constraints

private extension MainView {

    func hideLikedPlacesElements() {
        self.likedPlacesCollectionView.removeFromSuperview()
        self.likedPlacesLabel.removeFromSuperview()
    }

    func setupLikedPlacesElements() {
        self.setupLikedPlacesLabel()
        self.setupLikedPlacesCollectionView()
    }

    func setupLikedPlacesLabel() {
        self.addSubview(self.likedPlacesLabel)
        self.likedPlacesLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.likedPlacesLabel.topAnchor.constraint(equalTo: self.placesCollectionView.bottomAnchor,
                                                       constant: Constants.anchorConstant),
            self.likedPlacesLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                                                           constant: Constants.collectionViewSectionInset)
        ])
    }

    func setupLikedPlacesCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0,
                                           left: Constants.collectionViewSectionInset,
                                           bottom: 0,
                                           right: Constants.collectionViewSectionInset)
        self.likedPlacesCollectionView.setCollectionViewLayout(layout, animated: true)
        self.collectionViewLikedPlacesDelegate = MainScreenPlacesCollectionViewDelegate(withDelegate: self)
        self.likedPlacesCollectionView.delegate = self.collectionViewLikedPlacesDelegate
        self.likedPlacesCollectionView.dataSource = self.collectionViewLikedPlacesDataSource
        self.likedPlacesCollectionView.backgroundColor = UIColor.clear
        self.addSubview(self.likedPlacesCollectionView)
        self.likedPlacesCollectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.likedPlacesCollectionView.topAnchor.constraint(equalTo: self.likedPlacesLabel.bottomAnchor,
                                                                constant: Constants.anchorConstant),
            self.likedPlacesCollectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            self.likedPlacesCollectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            self.likedPlacesCollectionView.heightAnchor.constraint(equalToConstant: Constants.collectionViewHeight)
        ])
    }
}

extension MainView: IMainView {
    func setupPlacesCollectionView(places: [Place]) {
        self.collectionViewNearestPlacesDataSource.placesArray = places
        self.placesCollectionView.reloadData()
    }

    func setupLikedPlacesCollectionView(likedPlaces: [Place]) {
        if likedPlaces.count > 0 {
            self.setupLikedPlacesElements()
            self.collectionViewLikedPlacesDataSource.placesArray = likedPlaces
            self.likedPlacesCollectionView.reloadData()
        }
    }

    func hideLikedPlacesCollectionView() {
        self.hideLikedPlacesElements()
    }
}

extension MainView: IMainScreenPlacesDelegate {
    func selectedCell(collectionView: UICollectionView, indexPath: IndexPath) {
        if collectionView == self.placesCollectionView {
            self.nearestPlacesCellTapped?(indexPath)
        } else if collectionView == self.likedPlacesCollectionView {
            self.likedPlacesCellTapped?(indexPath)
        }
    }
}
