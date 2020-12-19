//
//  OneFoodView.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/8/20.
//

import UIKit

protocol IOneFoodView: class {
    var closeButtonTapped: (() -> Void)? { get set }
    var addFoodButtonTapped: (() -> Void)? { get set }
    
    func setupViewWithFood(_ food: Food,
                           withImage image: UIImage,
                           forVC oneFoodVCType: OneFoodInteractor.OneFoodFor)
}

// TODO: - Можно добавить информацию о товаре (калории/вес/и т.д.)

final class OneFoodView: UIView {
    
    // MARK: - Constants
    
    private enum Constants {
        static let topImageHeight: CGFloat = UIScreen.main.bounds.height * 0.25
        static let containerViewHeight: CGFloat = UIScreen.main.bounds.height * 0.60
        static let containerViewCornerRadius: CGFloat = 25
    }
    
    // MARK: - Views
    
    private let activityIndicator: UIActivityIndicatorView = {
        let myActivityIndicatorView = UIActivityIndicatorView()
        myActivityIndicatorView.hidesWhenStopped = true
        myActivityIndicatorView.startAnimating()
        return myActivityIndicatorView
    }()
    
    private let containerView: UIView = {
        let myView = UIView()
        myView.backgroundColor = .white
        return myView
    }()
    
    private var imageView: UIImageView = {
        let myImageView = UIImageView()
        myImageView.contentMode = .scaleAspectFit
        return myImageView
    }()
    
    private var closeViewButton: CustomCloseButton = {
        let myButton = CustomCloseButton()
        myButton.addTarget(self,
                           action: #selector(closeButtonTapped(gesture:)),
                           for: .touchUpInside)
        return myButton
    }()
    
    private var titleLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.textAlignment = .center
        myLabel.font = AppFonts.titleLabelFont
        myLabel.numberOfLines = 2
        return myLabel
    }()
    
    private var staticPriceLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.font = AppFonts.titleLabelFont
        myLabel.text = "Цена: "
        return myLabel
    }()
    
    private var priceLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.font = AppFonts.titleLabelFont
        return myLabel
    }()
    
    private var newPriceLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.font = AppFonts.titleLabelFont
        return myLabel
    }()
    
    private lazy var addFoodButton: CustomButton = {
        let myButton = CustomButton()
        myButton.setTitle("Добавить в корзину", for: .normal)
        myButton.addTarget(self,
                           action: #selector(addFoodButtonTapped(gesture:)),
                           for: .touchUpInside)
        myButton.accessibilityIdentifier = "addFoodButton"
        return myButton
    }()
    
    // MARK: - Properties
    
    var closeButtonTapped: (() -> Void)?
    var addFoodButtonTapped: (() -> Void)?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.setupContainerView()
        self.setupImageView()
        self.setupCloseViewButton()
        self.setupActivityIndicator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupContainerViewCorners()
    }
    
    func animatedViewPresentation() {
        UIView.animate(withDuration: AppConstants.AnimationTime.oneFoodContainerViewAnimationDuration) {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            self.containerView.transform = CGAffineTransform(translationX: 0,
                                                             y: -Constants.containerViewHeight)
        }
    }
    
    private func animatedViewDismiss(completion: @escaping (() -> Void)) {
        UIView.animate(withDuration: AppConstants.AnimationTime.oneFoodContainerViewAnimationDuration) {
            self.backgroundColor = UIColor.clear
            self.containerView.transform = CGAffineTransform(translationX: 0, y: 0)
        } completion: { (bool) in
            completion()
        }
    }
}

// MARK: - Обработки нажатий на кнопки

private extension OneFoodView {
    @objc func closeButtonTapped(gesture: UITapGestureRecognizer) {
        self.animatedViewDismiss { [weak self] in
            self?.closeButtonTapped?()
        }
    }
    
    @objc func addFoodButtonTapped(gesture: UITapGestureRecognizer) {
        self.animatedViewDismiss { [weak self] in
            self?.addFoodButtonTapped?()
        }
    }
}

// MARK: - IOneFoodView

extension OneFoodView: IOneFoodView {
    func setupViewWithFood(_ food: Food,
                           withImage image: UIImage,
                           forVC oneFoodVCType: OneFoodInteractor.OneFoodFor) {
        self.activityIndicator.stopAnimating()
        self.setupElements()
        guard let foodName = food.foodName else {
            assertionFailure("oops, something went wrong")
            return
        }
        self.imageView.image = image
        self.titleLabel.text = foodName
        if let foodPrice = food.foodPrice,
           let newFoodPrice = food.newFoodPrice {
            PriceLabelSetuper.makePriceLabels(foodPrice: foodPrice,
                                              newFoodPrice: newFoodPrice)
            { (color, priceLabelText, newPriceLabelText) in
                self.priceLabel.textColor = color
                self.priceLabel.text = priceLabelText
                self.newPriceLabel.attributedText = newPriceLabelText
            }
        }
        if oneFoodVCType == .basketVC {
            self.addFoodButton.isHidden = true
        } else if oneFoodVCType == .menuVC {
            self.addFoodButton.isHidden = false
        }
    }
}

// MARK: - UISetup

private extension OneFoodView {
    func setupElements() {
        self.setupTitleLabel()
        self.setupStaticPriceLabel()
        self.setupPriceLabel()
        self.setupNewPriceLabel()
        self.setupAddFoodButton()
    }
    
    func setupContainerView() {
        self.addSubview(self.containerView)
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.containerView.topAnchor.constraint(equalTo: self.bottomAnchor),
            self.containerView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            self.containerView.heightAnchor.constraint(equalToConstant: Constants.containerViewHeight)
        ])
    }
    
    func setupImageView() {
        self.containerView.addSubview(self.imageView)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
            self.imageView.heightAnchor.constraint(equalToConstant: Constants.topImageHeight)
        ])
    }
    
    func setupCloseViewButton() {
        self.containerView.addSubview(self.closeViewButton)
        self.closeViewButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.closeViewButton.topAnchor.constraint(
                equalTo: self.imageView.topAnchor,
                constant: AppConstants.Constraints.halfNormalAnchorConstaint),
            self.closeViewButton.trailingAnchor.constraint(
                equalTo: self.imageView.trailingAnchor,
                constant: -AppConstants.Constraints.halfNormalAnchorConstaint),
            self.closeViewButton.heightAnchor.constraint(
                equalToConstant: AppConstants.Sizes.closeViewButtonSize.height),
            self.closeViewButton.widthAnchor.constraint(
                equalToConstant: AppConstants.Sizes.closeViewButtonSize.width)
        ])
    }
    
    func setupTitleLabel() {
        self.containerView.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(
                equalTo: self.imageView.bottomAnchor,
                constant: AppConstants.Constraints.halfNormalAnchorConstaint),
            self.titleLabel.leadingAnchor.constraint(
                equalTo: self.containerView.leadingAnchor,
                constant: AppConstants.Constraints.halfNormalAnchorConstaint),
            self.titleLabel.trailingAnchor.constraint(
                equalTo: self.containerView.trailingAnchor,
                constant: -AppConstants.Constraints.halfNormalAnchorConstaint)
        ])
    }
    
    func setupStaticPriceLabel() {
        self.containerView.addSubview(self.staticPriceLabel)
        self.staticPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.staticPriceLabel.leadingAnchor.constraint(
                equalTo: self.containerView.leadingAnchor,
                constant: AppConstants.Constraints.halfNormalAnchorConstaint),
            self.staticPriceLabel.topAnchor.constraint(
                equalTo: self.titleLabel.bottomAnchor,
                constant: AppConstants.Constraints.halfNormalAnchorConstaint)
        ])
    }
    
    func setupPriceLabel() {
        self.containerView.addSubview(self.priceLabel)
        self.priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.priceLabel.leadingAnchor.constraint(equalTo: self.staticPriceLabel.trailingAnchor),
            self.priceLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor,
                                                 constant: AppConstants.Constraints.halfNormalAnchorConstaint)
        ])
    }
    
    func setupNewPriceLabel() {
        self.containerView.addSubview(self.newPriceLabel)
        self.newPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.newPriceLabel.leadingAnchor.constraint(
                equalTo: self.priceLabel.trailingAnchor,
                constant: AppConstants.Constraints.halfNormalAnchorConstaint),
            self.newPriceLabel.topAnchor.constraint(
                equalTo: self.titleLabel.bottomAnchor,
                constant: AppConstants.Constraints.halfNormalAnchorConstaint),
            self.newPriceLabel.trailingAnchor.constraint(
                equalTo: self.containerView.trailingAnchor,
                constant: -AppConstants.Constraints.halfNormalAnchorConstaint)
        ])
    }
    
    func setupAddFoodButton() {
        self.containerView.addSubview(self.addFoodButton)
        self.addFoodButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.addFoodButton.leadingAnchor.constraint(
                equalTo: self.containerView.leadingAnchor,
                constant: AppConstants.Constraints.halfNormalAnchorConstaint),
            self.addFoodButton.bottomAnchor.constraint(
                equalTo: self.containerView.safeAreaLayoutGuide.bottomAnchor,
                constant: -AppConstants.Constraints.halfNormalAnchorConstaint),
            self.addFoodButton.trailingAnchor.constraint(
                equalTo: self.containerView.trailingAnchor,
                constant: -AppConstants.Constraints.halfNormalAnchorConstaint),
            self.addFoodButton.heightAnchor.constraint(
                equalToConstant: AppConstants.Sizes.buttonsHeight)
        ])
    }
    
    // Закругление верхнего левого и верхнего правого углов
    func setupContainerViewCorners() {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(
                                    width: Constants.containerViewCornerRadius,
                                    height: Constants.containerViewCornerRadius))
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.containerView.layer.mask = mask
    }
}

// MARK: - Настройка activityIndicator-а, отображаемого при загрузке экрана

private extension OneFoodView {
    func setupActivityIndicator() {
        self.containerView.addSubview(self.activityIndicator)
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor)
        ])
    }
}

