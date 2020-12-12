//
//  PurchasingView.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/9/20.
//

import UIKit

protocol IPurchasingView: class {
    var selfPickupButtonTapped:  (() -> Void)? { get set }
    var toUserButtonTapped: (() -> Void)? { get set }
    var didSelectSegmentControl: ((String) -> Void)? { get set }
    var orderButtonTapped:  ((String?) -> Void)? { get set }

    func setupUserLocationOnUI()
    func setupSelfPickupOnUI()
    func setupTotalPriceLabel(totalPrice: String)
    func returnTimePresentation(timePresentation: [String])
    func hideTimeTextField()
    func showTimeTextField()
}

final class PurchasingView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let anchorConstant: CGFloat = 16
        static let orderButtonHeight: CGFloat = 50
        static let chosenButtonColor = UIColor.red
        static let unchosenButtonColor = UIColor.black.withAlphaComponent(0.2)
    }

    // MARK: - Views

    private let addresOfOrderLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.text = "Способ доставки:"
        myLabel.font = AppFonts.titleLabelFont
        myLabel.textAlignment = .center
        return myLabel
    }()

    private let toUserButton: CustomButton = {
        let myButton = CustomButton()
        myButton.addTarget(self,
                           action: #selector(toUserButtonTapped(gesture:)),
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

    private let orderTimeLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.text = "Время доставки:"
        myLabel.font = AppFonts.titleLabelFont
        return myLabel
    }()

    private let segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl()
        segmentControl.addTarget(self, action: #selector(segmentControlAction(sender:)), for: .valueChanged)
        return segmentControl
    }()

    private lazy var timeTextField: UITextField = {
        let myTextField = UITextField()
        myTextField.placeholder = "xx:xx"
        myTextField.delegate = self
        myTextField.borderStyle = .roundedRect
        return myTextField
    }()

    private let totalPriceLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.font = AppFonts.titleLabelFont
        myLabel.numberOfLines = 0
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

    var selfPickupButtonTapped:  (() -> Void)?
    var toUserButtonTapped: (() -> Void)?
    var didSelectSegmentControl: ((String) -> Void)?
    var orderButtonTapped:  ((String?) -> Void)?

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
        self.selfPickupButtonTapped?()
    }

    @objc func toUserButtonTapped(gesture: UIGestureRecognizer) {
        self.toUserButtonTapped?()
    }

    @objc func orderButtonTapped(gesture: UIGestureRecognizer) {
        orderButtonTapped?(self.timeTextField.text)
    }

    private func selfPickupButtonChosen() {
        self.toUserButton.backgroundColor = Constants.unchosenButtonColor
        self.selfPickupButton.backgroundColor = Constants.chosenButtonColor
    }

    private func toUserButtonChosen() {
        self.toUserButton.backgroundColor = Constants.chosenButtonColor
        self.selfPickupButton.backgroundColor = Constants.unchosenButtonColor
    }

    // MARK: - Обработка нажатия на segmentControl

    @objc func segmentControlAction(sender: UISegmentedControl) {
        self.selectSegmentControl(sender: sender)
    }

    private func selectSegmentControl(sender: UISegmentedControl) {
        guard let segmentControlTitle = segmentControl.titleForSegment(at: sender.selectedSegmentIndex) else {
            assertionFailure("Something went wrong")
            return
        }
        self.didSelectSegmentControl?(segmentControlTitle)
    }
}

// MARK: - IPurchasingView

extension PurchasingView: IPurchasingView {
    func setupUserLocationOnUI() {
        self.toUserButtonChosen()
    }

    func setupSelfPickupOnUI() {
        self.selfPickupButtonChosen()
    }

    func returnTimePresentation(timePresentation: [String]) {
        for timePresentation in timePresentation {
            let index = self.segmentControl.numberOfSegments
            self.segmentControl.insertSegment(withTitle: timePresentation,
                                              at: index,
                                              animated: true)
        }
        if self.segmentControl.numberOfSegments > 0 {
            self.segmentControl.selectedSegmentIndex = 0
            self.selectSegmentControl(sender: self.segmentControl)
        }
    }

    func hideTimeTextField() {
        self.timeTextField.isHidden = true
        self.timeTextField.text = nil
        self.timeTextField.resignFirstResponder()
    }

    func showTimeTextField() {
        self.timeTextField.isHidden = false
        self.timeTextField.becomeFirstResponder()
    }

    func setupTotalPriceLabel(totalPrice: String) {
        self.totalPriceLabel.text = "Полная стоимость заказа: \(totalPrice)"
    }
}

// MARK: - UISetup

private extension PurchasingView {
    func setupElements() {
        self.hideKeyboardWhenTappedAround()
        self.setupOrderTimeLabel()
        self.setupSegmentControl()
        self.setupTimeTextField()
        self.setupAddresOfOrderLabel()
        self.setupToUserButton()
        self.setupSelfPickupButton()

        self.setupOrderButton()
        self.setupTotalPriceLabel()
    }

    // Убираем клавиатуру, когда нажимаем куда-либо
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        self.endEditing(true)
    }

    func setupOrderTimeLabel() {
        self.addSubview(self.orderTimeLabel)
        self.orderTimeLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.orderTimeLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                                                   constant: Constants.anchorConstant),
            self.orderTimeLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                                                   constant: -Constants.anchorConstant),
            self.orderTimeLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor,
                                                   constant: Constants.anchorConstant)
        ])
    }

    func setupSegmentControl() {
        self.addSubview(self.segmentControl)
        self.segmentControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.segmentControl.topAnchor.constraint(equalTo: self.orderTimeLabel.bottomAnchor,
                                                     constant: Constants.anchorConstant),
            self.segmentControl.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            self.segmentControl.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    func setupTimeTextField() {
        self.addSubview(self.timeTextField)
        self.timeTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.timeTextField.topAnchor.constraint(equalTo: self.segmentControl.bottomAnchor,
                                                     constant: Constants.anchorConstant),
            self.timeTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                                                        constant: Constants.anchorConstant),
            self.timeTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                                                         constant: -Constants.anchorConstant)
        ])
    }

    func setupAddresOfOrderLabel() {
        self.addSubview(self.addresOfOrderLabel)
        self.addresOfOrderLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.addresOfOrderLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                                                   constant: Constants.anchorConstant),
            self.addresOfOrderLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                                                   constant: -Constants.anchorConstant),
            self.addresOfOrderLabel.topAnchor.constraint(equalTo: self.timeTextField.bottomAnchor,
                                                   constant: Constants.anchorConstant)
        ])
    }

    func setupToUserButton() {
        self.addSubview(self.toUserButton)
        self.toUserButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.toUserButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                                                   constant: Constants.anchorConstant),
            self.toUserButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                                                   constant: -Constants.anchorConstant),
            self.toUserButton.topAnchor.constraint(equalTo: self.addresOfOrderLabel.bottomAnchor,
                                                   constant: Constants.anchorConstant),
            self.toUserButton.heightAnchor.constraint(equalToConstant: Constants.orderButtonHeight)

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
            self.selfPickupButton.topAnchor.constraint(equalTo: self.toUserButton.bottomAnchor,
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

// MARK: - UITextFieldDelegate

extension PurchasingView: UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = self.timeTextField.text else { return }
        self.timeTextField.text = text.applyPatternOnNumbers(pattern: "##:##", replacmentCharacter: "#")
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let charsLimit = 5
        let startingLength = textField.text?.count ?? 0
        let lengthToAdd = string.count
        let lengthToReplace =  range.length
        let newLength = startingLength + lengthToAdd - lengthToReplace
        return newLength <= charsLimit
    }
}
