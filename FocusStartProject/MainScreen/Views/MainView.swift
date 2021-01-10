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
    func prepareForLikedPlaces()
}

final class MainView: UIView {
    
    // MARK: - Views
    
    private let nearestPlacesLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.text = "Ближайшие места:"
        myLabel.font = AppFonts.largeTitleLabelFont
        myLabel.accessibilityIdentifier = "nearestPlacesLabel"
        return myLabel
    }()
    
    private let placesCollectionView: UICollectionView = {
        let myCollectionView:UICollectionView = UICollectionView(
            frame: CGRect.zero,
            collectionViewLayout: UICollectionViewFlowLayout.init())
        myCollectionView.register(
            MainScreenCollectionViewCell.self,
            forCellWithReuseIdentifier: MainScreenCollectionViewCell.reuseIdentifier)
        myCollectionView.accessibilityIdentifier = "placesCollectionView"
        return myCollectionView
    }()
    
    private let likedPlacesLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.text = "Избранные места:"
        myLabel.font = AppFonts.largeTitleLabelFont
        return myLabel
    }()
    
    private let likedPlacesCollectionView: UICollectionView = {
        let myCollectionView:UICollectionView = UICollectionView(
            frame: CGRect.zero,
            collectionViewLayout: UICollectionViewFlowLayout.init())
        myCollectionView.register(
            MainScreenCollectionViewCell.self,
            forCellWithReuseIdentifier: MainScreenCollectionViewCell.reuseIdentifier)
        return myCollectionView
    }()
    
    private let likedPlacesActivityIndicatorView: UIActivityIndicatorView = {
        let myActivityIndicatorView = UIActivityIndicatorView()
        myActivityIndicatorView.hidesWhenStopped = true
        myActivityIndicatorView.startAnimating()
        return myActivityIndicatorView
    }()

    private lazy var emptyLikedPlacesLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.text = "Здесь вы сможете увидеть места, добавленные в избранные."
        myLabel.numberOfLines = 0
        myLabel.font = AppFonts.largeTitleLabelFont
        return myLabel
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
            self.nearestPlacesLabel.topAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.topAnchor,
                constant: AppConstants.Constraints.halfNormalAnchorConstaint),
            self.nearestPlacesLabel.leadingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                constant: AppConstants.Constraints.normalAnchorConstant)
        ])
    }
    
    func setupPlacesCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0,
                                           left: AppConstants.Constraints.normalAnchorConstant,
                                           bottom: 0,
                                           right: AppConstants.Constraints.normalAnchorConstant)
        self.placesCollectionView.setCollectionViewLayout(layout, animated: true)
        self.collectionViewNearestPlacesDelegate = MainScreenPlacesCollectionViewDelegate(withDelegate: self)
        self.placesCollectionView.delegate = self.collectionViewNearestPlacesDelegate
        self.placesCollectionView.dataSource = self.collectionViewNearestPlacesDataSource
        self.placesCollectionView.backgroundColor = UIColor.clear
        self.addSubview(self.placesCollectionView)
        self.placesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.placesCollectionView.topAnchor.constraint(
                equalTo: self.nearestPlacesLabel.bottomAnchor,
                constant: AppConstants.Constraints.halfNormalAnchorConstaint),
            self.placesCollectionView.leadingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            self.placesCollectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            self.placesCollectionView.heightAnchor.constraint(equalToConstant: AppConstants.Sizes.mainScreenCollectionViewHeight)
        ])
    }
}

// MARK: - Liked Places Constraints

private extension MainView {
    
    func hideLikedPlacesElements() {
        self.likedPlacesActivityIndicatorView.stopAnimating()
        self.likedPlacesCollectionView.removeFromSuperview()
        self.likedPlacesLabel.removeFromSuperview()
        self.setupEmptyLikedPlacesLabel()
    }

    func setupEmptyLikedPlacesLabel() {
        self.addSubview(self.emptyLikedPlacesLabel)
        self.emptyLikedPlacesLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.emptyLikedPlacesLabel.topAnchor.constraint(
                equalTo: self.placesCollectionView.bottomAnchor,
                constant: AppConstants.Constraints.twiceNormalAnchorConstant),
            self.emptyLikedPlacesLabel.leadingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                constant: AppConstants.Constraints.normalAnchorConstant),
            self.emptyLikedPlacesLabel.trailingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                constant: -AppConstants.Constraints.normalAnchorConstant)
        ])
    }
    
    func setupLikedPlacesElements() {
        self.emptyLikedPlacesLabel.removeFromSuperview()
        self.setupLikedPlacesLabel()
        self.setupLikedPlacesCollectionView()
    }
    
    func setupLikedPlacesLabel() {
        self.addSubview(self.likedPlacesLabel)
        self.likedPlacesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.likedPlacesLabel.topAnchor.constraint(
                equalTo: self.placesCollectionView.bottomAnchor,
                constant: AppConstants.Constraints.halfNormalAnchorConstaint),
            self.likedPlacesLabel.leadingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                constant: AppConstants.Constraints.normalAnchorConstant)
        ])
    }
    
    func setupLikedPlacesCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0,
                                           left: AppConstants.Constraints.normalAnchorConstant,
                                           bottom: 0,
                                           right: AppConstants.Constraints.normalAnchorConstant)
        self.likedPlacesCollectionView.setCollectionViewLayout(layout, animated: true)
        self.collectionViewLikedPlacesDelegate = MainScreenPlacesCollectionViewDelegate(withDelegate: self)
        self.likedPlacesCollectionView.delegate = self.collectionViewLikedPlacesDelegate
        self.likedPlacesCollectionView.dataSource = self.collectionViewLikedPlacesDataSource
        self.likedPlacesCollectionView.backgroundColor = UIColor.clear
        self.addSubview(self.likedPlacesCollectionView)
        self.likedPlacesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.likedPlacesCollectionView.topAnchor.constraint(
                equalTo: self.likedPlacesLabel.bottomAnchor,
                constant: AppConstants.Constraints.halfNormalAnchorConstaint),
            self.likedPlacesCollectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            self.likedPlacesCollectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            self.likedPlacesCollectionView.heightAnchor.constraint(equalToConstant: AppConstants.Sizes.mainScreenCollectionViewHeight)
        ])
    }
    
    func setupLikedPlacesActivityIndicatorView() {
        self.addSubview(self.likedPlacesActivityIndicatorView)
        self.likedPlacesActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.likedPlacesActivityIndicatorView.centerXAnchor.constraint(
                equalTo: self.centerXAnchor),
            self.likedPlacesActivityIndicatorView.topAnchor.constraint(
                equalTo: self.placesCollectionView.bottomAnchor,
                constant: AppConstants.Sizes.mainScreenCollectionViewHeight/2)
        ])
    }
}

// MARK: - IMainView

extension MainView: IMainView {
    func setupPlacesCollectionView(places: [Place]) {
        self.collectionViewNearestPlacesDataSource.placesArray = places
        self.placesCollectionView.reloadData()
    }
    
    func setupLikedPlacesCollectionView(likedPlaces: [Place]) {
        self.likedPlacesActivityIndicatorView.stopAnimating()
        // Убираем элементы с collectionView
        // (Без этого при удалении первого элемента в collectionView
        // они не сдвигались и collectionViewCell показывала неверную информацию
        // хотя переход осуществлялся на нужное заведение)
        self.collectionViewLikedPlacesDataSource.placesArray = []
        self.likedPlacesCollectionView.reloadData()
        if likedPlaces.count > 0 {
            self.setupLikedPlacesElements()
        } else {
            self.hideLikedPlacesElements()
        }
        self.collectionViewLikedPlacesDataSource.placesArray = likedPlaces
        self.likedPlacesCollectionView.reloadData()
    }
    
    func prepareForLikedPlaces() {
        self.setupLikedPlacesActivityIndicatorView()
    }
}

// MARK: - IMainScreenPlacesDelegate
// Custom CollectionView Delegate, обработка тапа на ячейки

extension MainView: IMainScreenPlacesDelegate {
    func selectedCell(collectionView: UICollectionView, indexPath: IndexPath) {
        if collectionView == self.placesCollectionView {
            self.nearestPlacesCellTapped?(indexPath)
        } else if collectionView == self.likedPlacesCollectionView {
            self.likedPlacesCellTapped?(indexPath)
        }
    }
}
