//
//  OneOrderView.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/12/20.
//

import UIKit

protocol IOneOrderView: class {
    func setupUIFor(order: HistoryOrderEntity, foodImage: UIImage)
    func setupUIFor(order: HistoryOrderEntity)
}

final class OneOrderView: UIView {
    
    // MARK: - Views
    
    private let activityIndicator: UIActivityIndicatorView = {
        let myActivityIndicatorView = UIActivityIndicatorView()
        myActivityIndicatorView.hidesWhenStopped = true
        myActivityIndicatorView.startAnimating()
        return myActivityIndicatorView
    }()
    
    private lazy var timeLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.font = AppFonts.titleLabelFont
        myLabel.textAlignment = .right
        return myLabel
    }()
    
    private lazy var foodImageView: UIImageView = {
        let myImageView = UIImageView()
        myImageView.contentMode = .scaleAspectFit
        return myImageView
    }()
    
    private lazy var foodNameLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.font = AppFonts.titleLabelFont
        myLabel.textAlignment = .center
        myLabel.numberOfLines = 0
        return myLabel
    }()
    
    private lazy var staticPriceLabel: UILabel={
        let myLabel = UILabel()
        myLabel.font = AppFonts.titleLabelFont
        myLabel.text = "Цена: "
        return myLabel
    }()
    
    private lazy var priceLabel: UILabel={
        let myLabel = UILabel()
        myLabel.font = AppFonts.titleLabelFont
        return myLabel
    }()
    
    private lazy var newPriceLabel: UILabel={
        let myLabel = UILabel()
        myLabel.font = AppFonts.titleLabelFont
        return myLabel
    }()
    
    private lazy var fromPlaceLabel: UILabel={
        let myLabel = UILabel()
        myLabel.font = AppFonts.titleLabelFont
        myLabel.numberOfLines = 0
        return myLabel
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        self.setupActivityIndicator()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - IOneOrderView

extension OneOrderView: IOneOrderView {
    func setupUIFor(order: HistoryOrderEntity,
                    foodImage: UIImage) {
        self.setupElements()
        self.setupTexts(order: order)
        self.foodImageView.image = foodImage
    }
    
    func setupUIFor(order: HistoryOrderEntity) {
        self.setupElements()
        self.setupTexts(order: order)
    }
    
    private func setupTexts(order: HistoryOrderEntity) {
        self.activityIndicator.stopAnimating()
        self.timeLabel.text = "Заказ от \(order.time)"
        self.foodNameLabel.text = order.food
        self.fromPlaceLabel.text = "Заказано в:\n\(order.from)"
        PriceLabelSetuper.makePriceLabels(foodPrice: order.price, newFoodPrice: order.newPrice) { (color, priceLabelText, newPriceLabelText) in
            self.priceLabel.textColor = color
            self.priceLabel.text = priceLabelText
            self.newPriceLabel.attributedText = newPriceLabelText
        }
    }
}

// MARK: - UISetup

private extension OneOrderView {
    func setupActivityIndicator() {
        self.addSubview(self.activityIndicator)
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func setupElements() {
        self.setupTimeLabel()
        self.setupFoodImageView()
        self.setupFoodNameLabel()
        self.setupStaticPriceLabel()
        self.setupPriceLabel()
        self.setupNewPriceLabel()
        self.setupFromPlaceLabel()
    }
    
    func setupTimeLabel() {
        self.addSubview(self.timeLabel)
        self.timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.timeLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                                                    constant: AppConstants.Constraints.normalAnchorConstant),
            self.timeLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor,
                                                constant: AppConstants.Constraints.normalAnchorConstant),
            self.timeLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                                                     constant: -AppConstants.Constraints.normalAnchorConstant),
        ])
    }
    
    func setupFoodImageView() {
        self.addSubview(self.foodImageView)
        self.foodImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.foodImageView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                                                        constant: AppConstants.Constraints.normalAnchorConstant),
            self.foodImageView.topAnchor.constraint(equalTo: self.timeLabel.bottomAnchor,
                                                    constant: AppConstants.Constraints.normalAnchorConstant),
            self.foodImageView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                                                         constant: -AppConstants.Constraints.normalAnchorConstant),
            self.foodImageView.heightAnchor.constraint(equalToConstant: AppConstants.screenHeight * 0.4)
        ])
    }
    
    
    func setupFoodNameLabel() {
        self.addSubview(self.foodNameLabel)
        self.foodNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.foodNameLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                                                        constant: AppConstants.Constraints.normalAnchorConstant),
            self.foodNameLabel.topAnchor.constraint(equalTo: self.foodImageView.bottomAnchor,
                                                    constant: AppConstants.Constraints.normalAnchorConstant),
            self.foodNameLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                                                         constant: -AppConstants.Constraints.normalAnchorConstant),
        ])
    }
    
    func setupStaticPriceLabel() {
        self.addSubview(self.staticPriceLabel)
        self.staticPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.staticPriceLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                                                           constant: AppConstants.Constraints.normalAnchorConstant),
            self.staticPriceLabel.topAnchor.constraint(equalTo: self.foodNameLabel.bottomAnchor,
                                                       constant: AppConstants.Constraints.normalAnchorConstant)
        ])
    }
    
    func setupPriceLabel() {
        self.addSubview(self.priceLabel)
        self.priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.priceLabel.leadingAnchor.constraint(equalTo: self.staticPriceLabel.trailingAnchor),
            self.priceLabel.topAnchor.constraint(equalTo: self.foodNameLabel.bottomAnchor,
                                                 constant: AppConstants.Constraints.normalAnchorConstant)
        ])
    }
    
    func setupNewPriceLabel() {
        self.addSubview(self.newPriceLabel)
        self.newPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.newPriceLabel.leadingAnchor.constraint(equalTo: self.priceLabel.trailingAnchor,
                                                        constant: AppConstants.Constraints.normalAnchorConstant),
            self.newPriceLabel.topAnchor.constraint(equalTo: self.foodNameLabel.bottomAnchor,
                                                    constant: AppConstants.Constraints.normalAnchorConstant),
            self.newPriceLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                                                         constant: -AppConstants.Constraints.normalAnchorConstant)
        ])
    }
    
    func setupFromPlaceLabel() {
        self.addSubview(self.fromPlaceLabel)
        self.fromPlaceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.fromPlaceLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                                                         constant: AppConstants.Constraints.normalAnchorConstant),
            self.fromPlaceLabel.topAnchor.constraint(equalTo: self.staticPriceLabel.bottomAnchor,
                                                     constant: AppConstants.Constraints.normalAnchorConstant),
            self.fromPlaceLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                                                          constant: -AppConstants.Constraints.normalAnchorConstant)
        ])
    }
}
