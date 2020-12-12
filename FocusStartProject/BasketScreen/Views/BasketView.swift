//
//  BasketView.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/8/20.
//

import UIKit

protocol IBasketView: class {
    var cellTapped: ((IndexPath) -> Void)? { get set }
    var orderButtonTapped: (() -> Void)? { get set }

    func setupCollectionView(withFoodArray foodArray: [Food])
}

final class BasketView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let anchorConstant: CGFloat = 16
        static let collectionViewSectionInset: CGFloat = 16
        static let collectionViewSectionTopInset: CGFloat = 32
        static let orderButtonHeight: CGFloat = 50
    }

    // MARK: - Views

    private var topLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.text = "Список добавленных товаров:"
        myLabel.font = AppFonts.titleLabelFont
        myLabel.numberOfLines = 0
        return myLabel
    }()

    private lazy var collectionView: UICollectionView = {
        let myCollectionView = UICollectionView(frame: CGRect.zero,
                                                                 collectionViewLayout: UICollectionViewFlowLayout.init())
        myCollectionView.register(MenuCollectionViewCell.self,
                                  forCellWithReuseIdentifier: MenuCollectionViewCell.reuseIdentifier)
        myCollectionView.backgroundColor = .systemBackground
        return myCollectionView
    }()

    private let orderButton: CustomButton={
        let myButton = CustomButton()
        myButton.setTitle("Перейти к оформлению", for: .normal)
        myButton.addTarget(self, action: #selector(orderButtonTapped(gesute:)), for: .touchUpInside)
        return myButton
    }()


    // MARK: - Properties

    private var collectionViewDataSource = MenuScreenCollectionViewDataSource()
    private var collectionViewDelegate: MenuScreenCollectionViewDelegate?
    var cellTapped: ((IndexPath) -> Void)?
    var orderButtonTapped: (() -> Void)?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        self.setupElements()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - orderButtonTapped

    @objc private func orderButtonTapped(gesute: UIGestureRecognizer) {
        self.orderButtonTapped?()
    }
}

// MARK: - IBasketView

extension BasketView: IBasketView {
    func setupCollectionView(withFoodArray foodArray: [Food]) {
        self.collectionViewDataSource.foodArray = foodArray
        self.collectionView.reloadData()
    }
}

// MARK: - UISetup

private extension BasketView {
    func setupElements() {
        self.setupTopLabel()
        self.setupOrderButton()
        self.setupPlacesCollectionView()
    }

    func setupTopLabel() {
        self.addSubview(self.topLabel)
        self.topLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.topLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                                                   constant: Constants.anchorConstant),
            self.topLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                                                   constant: -Constants.anchorConstant),
            self.topLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor,
                                                   constant: Constants.anchorConstant)

        ])
    }

    func setupOrderButton() {
        self.addSubview(self.orderButton)
        self.orderButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.orderButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                                                   constant: Constants.anchorConstant),
            self.orderButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                                                   constant: -Constants.anchorConstant),
            self.orderButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor,
                                                   constant: -Constants.anchorConstant),
            self.orderButton.heightAnchor.constraint(equalToConstant: Constants.orderButtonHeight)

        ])
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
            self.collectionView.topAnchor.constraint(equalTo: self.topLabel.bottomAnchor,
                                                     constant: Constants.anchorConstant),
            self.collectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.orderButton.topAnchor,
                                                        constant: -Constants.anchorConstant)
        ])
    }
}

// MARK: - IMenuScreenPlacesDelegate

extension BasketView: IMenuScreenPlacesDelegate {
    func selectedCell(indexPath: IndexPath) {
        self.cellTapped?(indexPath)
    }
}
