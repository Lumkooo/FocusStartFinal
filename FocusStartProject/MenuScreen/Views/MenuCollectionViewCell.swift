//
//  MenuCollectionViewCell.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/8/20.
//

import UIKit

final class MenuCollectionViewCell: UICollectionViewCell {

    // MARK: - Constants

    private enum Constants {
        static let cornerRadius: CGFloat = 15
        static let borderWidth: CGFloat = 5
        static let shadowRadius: CGFloat = 6
        static let shadowOpacity: Float = 1
        static let anchorConstant: CGFloat = 16
        static let labelAnchorConstant: CGFloat = 4
        static let spaceBetweenPriceLabels: CGFloat = 8
        static let imageViewHeightMulitplier: CGFloat = 0.65
        static let titleFontConstant:CGFloat = 0.02
        static let priceFontConstant:CGFloat = 0.018
        static let screenHeight:CGFloat = UIScreen.main.bounds.height
    }

    // MARK: - Fonts

    private enum Fonts {
        static let titleLabelFont = UIFont.systemFont(
            ofSize: Constants.titleFontConstant * Constants.screenHeight
            ,weight: .light)
        static let priceLabelFont = UIFont.systemFont(
            ofSize: Constants.priceFontConstant * Constants.screenHeight
            ,weight: .light)
    }

    // MARK: - Properties

    static var reuseIdentifier: String {
        return String(describing: MenuCollectionViewCell.self)
    }
    private var placeName: String?
    private var foodName: String?
    private var stringImageURL: String?{
        didSet{
            imageView.image = nil
            updateUI()
        }
    }

    // MARK: - Views

    private var imageView: UIImageView={
        let myImageView = UIImageView()
        myImageView.contentMode = .scaleAspectFit
        return myImageView
    }()

    private var titleLabel: UILabel={
        let myLabel = UILabel()
        myLabel.font = Fonts.titleLabelFont
        myLabel.numberOfLines = 3
        return myLabel
    }()

    private var staticPriceLabel: UILabel={
        let myLabel = UILabel()
        myLabel.font = Fonts.priceLabelFont
        myLabel.text = "Цена: "
        return myLabel
    }()

    private var priceLabel: UILabel={
        let myLabel = UILabel()
        myLabel.font = Fonts.priceLabelFont
        return myLabel
    }()

    private var newPriceLabel: UILabel={
        let myLabel = UILabel()
        myLabel.font = Fonts.priceLabelFont
        return myLabel
    }()

    private var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.color = .black
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupElements()
        self.setupLayer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - updateUI

    private func updateUI(){
        self.activityIndicatorView.startAnimating()
        if let stringURL = self.stringImageURL,
           let placeName = self.placeName,
           let foodName = self.foodName {
            ImageCache.loadImage(urlString: stringURL,nameOfPicture: "\(placeName)-\(foodName)") { (urlString, image) in
                self.imageView.image = image
                self.activityIndicatorView.stopAnimating()
            }
        } else {
            // TODO: - Поставить сюда картинку неудачной загрузки картинки
            assertionFailure("Something went wrong")
        }
    }

    override func prepareForReuse() {
        self.imageView.image = UIImage()
        updateUI()
    }

    // MARK: - setupCell from DataSource

    func setupCell(forFood food: Food) {
        guard let placeName = food.placeName,
              let foodName = food.foodName else {
            assertionFailure("Ooops, something went wrong")
            return
        }

        self.placeName = placeName
        self.foodName = foodName
        self.titleLabel.text = foodName
        self.stringImageURL = food.imageURL

        // Label-ы цены, в случае, если на товар скидка, то пишется старая цена (перечеркнута)
        // и новая цена красным цветом
        if let foodPrice = food.foodPrice,
           let newFoodPrice = food.newFoodPrice {
            PriceLabelSetuper.makePriceLabels(foodPrice: foodPrice, newFoodPrice: newFoodPrice) { (color, priceLabelText, newPriceLabelText) in
                self.priceLabel.textColor = color
                self.priceLabel.text = priceLabelText
                self.newPriceLabel.attributedText = newPriceLabelText
            }
        }
    }
}

// MARK: - UI setup

private extension MenuCollectionViewCell {
    func setupElements() {
        self.setupImageView()
        self.setupStaticPriceLabel()
        self.setupPriceLabel()
        self.setupNewPriceLabel()
        self.setupTitleLabel()
        self.setupActivityIndicatorView()
    }

    func setupImageView() {
        self.contentView.addSubview(self.imageView)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.imageView.heightAnchor.constraint(equalToConstant:
                                                    self.contentView.frame.height * Constants.imageViewHeightMulitplier)
        ])
    }

    func setupStaticPriceLabel() {
        self.contentView.addSubview(self.staticPriceLabel)
        self.staticPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.staticPriceLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,
                                                     constant: Constants.labelAnchorConstant),
            self.staticPriceLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,
                                                 constant: -Constants.labelAnchorConstant)
        ])
    }

    func setupPriceLabel() {
        self.contentView.addSubview(self.priceLabel)
        self.priceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.priceLabel.leadingAnchor.constraint(equalTo: self.staticPriceLabel.trailingAnchor),
            self.priceLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,
                                                 constant: -Constants.labelAnchorConstant)
        ])
    }

    func setupNewPriceLabel() {
        self.contentView.addSubview(self.newPriceLabel)
        self.newPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.newPriceLabel.leadingAnchor.constraint(equalTo: self.priceLabel.trailingAnchor,
                                                     constant: Constants.spaceBetweenPriceLabels),
            self.newPriceLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,
                                                      constant: -Constants.labelAnchorConstant),
            self.newPriceLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,
                                                    constant: -Constants.labelAnchorConstant)
        ])
    }

    func setupTitleLabel() {
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,
                                                     constant: Constants.labelAnchorConstant),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,
                                                      constant: -Constants.labelAnchorConstant),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.priceLabel.topAnchor,
                                                    constant: -Constants.labelAnchorConstant),
        ])
    }

    func setupActivityIndicatorView() {
        self.imageView.addSubview(self.activityIndicatorView)
        self.activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.activityIndicatorView.centerYAnchor.constraint(equalTo: self.imageView.centerYAnchor),
            self.activityIndicatorView.centerXAnchor.constraint(equalTo: self.imageView.centerXAnchor)
        ])
    }

    func setupLayer() {
        self.layer.cornerRadius = Constants.cornerRadius
        self.layer.borderWidth = Constants.borderWidth
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true
        self.backgroundColor = .systemBackground

        self.contentView.layer.cornerRadius = Constants.cornerRadius
        self.contentView.layer.borderWidth = Constants.borderWidth
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = Constants.shadowRadius
        self.layer.shadowOpacity = Constants.shadowOpacity
        self.layer.cornerRadius = Constants.cornerRadius
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds,
                                             cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
}
