//
//  PurchasingView.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/9/20.
//

import UIKit

protocol IPurchasingView: class {

}

final class PurchasingView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let anchorConstant: CGFloat = 16
        static let orderButtonHeight: CGFloat = 50
        static let chosenButtonColor = UIColor.red
        static let unchosenButtonColor = UIColor.black.withAlphaComponent(0.2)
    }

    // MARK: - Fonts

    private enum Fonts {
        static let labelsFont = UIFont.systemFont(ofSize: 20, weight: .light)
    }

    // MARK: - Views

    private let addresOfOrderLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.text = "Способ доставки:"
        myLabel.font = Fonts.labelsFont
        myLabel.textAlignment = .center
        return myLabel
    }()

    private let toMeButton: CustomButton = {
        let myButton = CustomButton()
        myButton.addTarget(self,
                           action: #selector(toMeButtonTapped(gesture:)),
                           for: .touchUpInside)
        myButton.setTitle("По моему местоположению", for: .normal)
        myButton.backgroundColor = Constants.unchosenButtonColor
        return myButton
    }()

    private let selfPickupButton: CustomButton = {
        let myButton = CustomButton()
        myButton.addTarget(self,
                           action: #selector(selfPickupButtonTapped(gesture:)),
                           for: .touchUpInside)
        myButton.setTitle("Самовывоз", for: .normal)
        myButton.backgroundColor = Constants.unchosenButtonColor
        return myButton
    }()


    private let totalPriceLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.text = "Полная стоимость заказа:"
        myLabel.font = Fonts.labelsFont
        return myLabel
    }()

    private let orderButton: CustomButton = {
        let myButton = CustomButton()
        myButton.addTarget(self,
                           action: #selector(orderButtonTapped(gesture:)),
                           for: .touchUpInside)
        myButton.setTitle("Оформить заказ", for: .normal)
        return myButton
    }()

    // MARK: - Properties

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        self.setupElements()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Обработка нажатий на кнопки

    @objc func selfPickupButtonTapped(gesture: UIGestureRecognizer) {
        print("selfPickupButtonTapped")
        self.toMeButton.backgroundColor = Constants.unchosenButtonColor
        self.selfPickupButton.backgroundColor = Constants.chosenButtonColor
    }

    @objc func toMeButtonTapped(gesture: UIGestureRecognizer) {
        print("toMeButtonTapped")
        self.toMeButton.backgroundColor = Constants.chosenButtonColor
        self.selfPickupButton.backgroundColor = Constants.unchosenButtonColor
    }

    @objc func orderButtonTapped(gesture: UIGestureRecognizer) {
        print("orderButtonTapped")
    }
}

// MARK: - IPurchasingView

extension PurchasingView: IPurchasingView {

}

// MARK: - UISetup

private extension PurchasingView {
    func setupElements() {
        self.setupAddresOfOrderLabel()
        self.setupToMeButton()
        self.setupSelfPickupButton()

        self.setupOrderButton()
        self.setupTotalPriceLabel()
    }

    func setupAddresOfOrderLabel() {
        self.addSubview(self.addresOfOrderLabel)
        self.addresOfOrderLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.addresOfOrderLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                                                   constant: Constants.anchorConstant),
            self.addresOfOrderLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                                                   constant: -Constants.anchorConstant),
            self.addresOfOrderLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor,
                                                   constant: Constants.anchorConstant)
        ])
    }

    func setupToMeButton() {
        self.addSubview(self.toMeButton)
        self.toMeButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.toMeButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                                                   constant: Constants.anchorConstant),
            self.toMeButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                                                   constant: -Constants.anchorConstant),
            self.toMeButton.topAnchor.constraint(equalTo: self.addresOfOrderLabel.bottomAnchor,
                                                   constant: Constants.anchorConstant),
            self.toMeButton.heightAnchor.constraint(equalToConstant: Constants.orderButtonHeight)

        ])
    }

    func setupSelfPickupButton() {
        self.addSubview(self.selfPickupButton)
        self.selfPickupButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.selfPickupButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                                                   constant: Constants.anchorConstant),
            self.selfPickupButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                                                   constant: -Constants.anchorConstant),
            self.selfPickupButton.topAnchor.constraint(equalTo: self.toMeButton.bottomAnchor,
                                                   constant: Constants.anchorConstant),
            self.selfPickupButton.heightAnchor.constraint(equalToConstant: Constants.orderButtonHeight)
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

    func setupTotalPriceLabel() {
        self.addSubview(self.totalPriceLabel)
        self.totalPriceLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.totalPriceLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                                                   constant: Constants.anchorConstant),
            self.totalPriceLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                                                   constant: -Constants.anchorConstant),
            self.totalPriceLabel.bottomAnchor.constraint(equalTo: self.orderButton.topAnchor,
                                                   constant: -Constants.anchorConstant)
        ])
    }
}
