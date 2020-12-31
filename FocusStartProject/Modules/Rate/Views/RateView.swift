//
//  RateView.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/26/20.
//

import UIKit

protocol IRateView: class {
    var firstButtonTapped: (() -> Void)? { get set }
    var secondButtonTapped: (() -> Void)? { get set }
    var thirdButtonTapped: (() -> Void)? { get set }
    var fourthButtonTapped: (() -> Void)? { get set }
    var fifthButtonTapped: (() -> Void)? { get set }
    var doneButtonTapped: (() -> Void)? { get set }

    func setupRatingLabel(ratingCount: Int, currentRating: Double)
}

final class RateView: UIView {

    private enum StarState {
        case star
        case starFilled

        var image: UIImage? {
            if self == .star {
                return AppConstants.Images.starImage
            } else {
                return AppConstants.Images.starFilledImage
            }
        }
    }
    // MARK: - Views

    private let stackView: UIStackView = {
        let myStackView   = UIStackView()
        myStackView.axis  = .horizontal
        myStackView.distribution  = .fillEqually
        myStackView.alignment = .center
        return myStackView
    }()

    private let firstStarButton: UIButton = {
        let myButton = UIButton()
        myButton.setImage(AppConstants.Images.starImage, for: .normal)
        myButton.addTarget(self,
                           action: #selector(firstStarTapped),
                           for: .touchUpInside)
        myButton.tintColor = .systemYellow
        return myButton
    }()

    private let secondStarButton: UIButton = {
        let myButton = UIButton()
        myButton.setImage(AppConstants.Images.starImage, for: .normal)
        myButton.addTarget(self,
                           action: #selector(secondStarTapped),
                           for: .touchUpInside)
        myButton.tintColor = .systemYellow
        return myButton
    }()

    private let thirdStarButton: UIButton = {
        let myButton = UIButton()
        myButton.setImage(AppConstants.Images.starImage, for: .normal)
        myButton.addTarget(self,
                           action: #selector(thirdStarTapped),
                           for: .touchUpInside)
        myButton.tintColor = .systemYellow
        return myButton
    }()

    private let fourthStarButton: UIButton = {
        let myButton = UIButton()
        myButton.setImage(AppConstants.Images.starImage, for: .normal)
        myButton.addTarget(self,
                           action: #selector(fourthStarTapped),
                           for: .touchUpInside)
        myButton.tintColor = .systemYellow
        return myButton
    }()

    private let fifthStarButton: UIButton = {
        let myButton = UIButton()
        myButton.setImage(AppConstants.Images.starImage, for: .normal)
        myButton.addTarget(self,
                           action: #selector(fifthStarTapped),
                           for: .touchUpInside)
        myButton.tintColor = .systemYellow
        return myButton
    }()

    private let doneButton: CustomButton = {
        let myCustomButton = CustomButton()
        myCustomButton.setTitle("Поставить оценку", for: .normal)
        myCustomButton.addTarget(self,
                                 action: #selector(doneTapped),
                                 for: .touchUpInside)
        return myCustomButton
    }()

    private let currentRatingLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.font = AppFonts.titleLabelFont
        myLabel.textAlignment = .center
        myLabel.numberOfLines = 0
        return myLabel
    }()

    private let chosenRatingLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.font = AppFonts.titleLabelFont
        myLabel.textAlignment = .center
        return myLabel
    }()


    // MARK: - Properties

    var firstButtonTapped: (() -> Void)?
    var secondButtonTapped: (() -> Void)?
    var thirdButtonTapped: (() -> Void)?
    var fourthButtonTapped: (() -> Void)?
    var fifthButtonTapped: (() -> Void)?
    var doneButtonTapped: (() -> Void)?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupElements()
        self.backgroundColor = .systemBackground
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Обработка нажатий на кнопки

    @objc func firstStarTapped() {
        setupStars(firstStar: .starFilled,
                   secondStar: .star,
                   thirdStar: .star,
                   fourthStar: .star,
                   fifthStar: .star)
        self.setupChosenRatingLabelText(withRating: 1)
        self.firstButtonTapped?()
    }

    @objc func secondStarTapped() {
        setupStars(firstStar: .starFilled,
                   secondStar: .starFilled,
                   thirdStar: .star,
                   fourthStar: .star,
                   fifthStar: .star)
        self.setupChosenRatingLabelText(withRating: 2)
        self.secondButtonTapped?()
    }

    @objc func thirdStarTapped() {
        setupStars(firstStar: .starFilled,
                   secondStar: .starFilled,
                   thirdStar: .starFilled,
                   fourthStar: .star,
                   fifthStar: .star)
        self.setupChosenRatingLabelText(withRating: 3)
        self.thirdButtonTapped?()
    }

    @objc func fourthStarTapped() {
        setupStars(firstStar: .starFilled,
                   secondStar: .starFilled,
                   thirdStar: .starFilled,
                   fourthStar: .starFilled,
                   fifthStar: .star)
        self.setupChosenRatingLabelText(withRating: 4)
        self.fourthButtonTapped?()
    }

    @objc func fifthStarTapped() {
        setupStars(firstStar: .starFilled,
                   secondStar: .starFilled,
                   thirdStar: .starFilled,
                   fourthStar: .starFilled,
                   fifthStar: .starFilled)
        self.setupChosenRatingLabelText(withRating: 5)
        self.fifthButtonTapped?()
    }

    @objc func doneTapped() {
        self.doneButtonTapped?()
    }

    private func setupChosenRatingLabelText(withRating rating: Int) {
        self.chosenRatingLabel.text = "Ваша оценка: \(rating)"
    }

    private func setupStars(firstStar: StarState,
                            secondStar: StarState,
                            thirdStar: StarState,
                            fourthStar: StarState,
                            fifthStar: StarState) {
        self.firstStarButton.setImage(firstStar.image, for: .normal)
        self.secondStarButton.setImage(secondStar.image, for: .normal)
        self.thirdStarButton.setImage(thirdStar.image, for: .normal)
        self.fourthStarButton.setImage(fourthStar.image, for: .normal)
        self.fifthStarButton.setImage(fifthStar.image, for: .normal)
    }
}


// MARK: IRateView

extension RateView: IRateView {
    func setupRatingLabel(ratingCount: Int, currentRating: Double) {
        if ratingCount == 0{
            self.currentRatingLabel.text = "Пока еще никто не ставил оценку этому заведению"
        } else {
            self.currentRatingLabel.text = "Рейтинг заведения - \(currentRating)\nРезультат основан на \(ratingCount) отзывах"
        }
    }
}

// MARK: - UISetup

private extension RateView {
    func setupElements() {
        self.setupStackView()
        self.setupDoneButton()
        self.setupCurrentRatingLabel()
        self.setupChosenRatingLabel()
    }

    func setupStackView() {
        stackView.addArrangedSubview(self.firstStarButton)
        stackView.addArrangedSubview(self.secondStarButton)
        stackView.addArrangedSubview(self.thirdStarButton)
        stackView.addArrangedSubview(self.fourthStarButton)
        stackView.addArrangedSubview(self.fifthStarButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)

        NSLayoutConstraint.activate([
            self.stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.stackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                                                    constant: AppConstants.Constraints.halfNormalAnchorConstaint),
            self.stackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                                                    constant: -AppConstants.Constraints.halfNormalAnchorConstaint),
            // AppConstants.screenWidth/5 для того, чтобы изображения соотношение
            // высоты и ширины звезд были примерно 1:1
            self.stackView.heightAnchor.constraint(equalToConstant: AppConstants.screenWidth/5)

        ])
    }

    func setupDoneButton() {
        self.addSubview(self.doneButton)
        self.doneButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.doneButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                                                     constant: AppConstants.Constraints.normalAnchorConstant),
            self.doneButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                                                     constant: -AppConstants.Constraints.normalAnchorConstant),
            self.doneButton.heightAnchor.constraint(equalToConstant: AppConstants.Sizes.buttonsHeight),
            self.doneButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor,
                                                    constant: -AppConstants.Constraints.normalAnchorConstant)
        ])
    }

    func setupCurrentRatingLabel() {
        self.addSubview(self.currentRatingLabel)
        self.currentRatingLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.currentRatingLabel.leadingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                constant: AppConstants.Constraints.normalAnchorConstant),
            self.currentRatingLabel.trailingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                constant: -AppConstants.Constraints.normalAnchorConstant),
            self.currentRatingLabel.topAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.topAnchor,
                constant: AppConstants.Constraints.normalAnchorConstant)
        ])
    }

    func setupChosenRatingLabel() {
        self.addSubview(self.chosenRatingLabel)
        self.chosenRatingLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.chosenRatingLabel.leadingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                constant: AppConstants.Constraints.normalAnchorConstant),
            self.chosenRatingLabel.trailingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                constant: -AppConstants.Constraints.normalAnchorConstant),
            self.chosenRatingLabel.topAnchor.constraint(
                equalTo: self.stackView.bottomAnchor,
                constant: AppConstants.Constraints.twiceNormalAnchorConstant)
        ])
    }
}
