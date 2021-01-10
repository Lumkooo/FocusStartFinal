//
//  NoConnectionView.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/18/20.
//

import UIKit

protocol INoConnectionView: class {
    var checkConnectionToInternet: (() -> Void)? { get set }
    var connectionEnabled: (() -> Void)? { get set }

    func connection(isConnectionEnabled: Bool)
}

final class NoConnectionView: UIView {
    
    // MARK: - Views
    
    private lazy var firstBoyImageView: UIImageView = {
        let myImageView = UIImageView()
        myImageView.image = AppConstants.Images.noConnection1
        return myImageView
    }()
    
    private lazy var firstGirlImageView: UIImageView = {
        let myImageView = UIImageView()
        myImageView.image = AppConstants.Images.noConnection2
        return myImageView
    }()
    
    private lazy var secondGirlImageView: UIImageView = {
        let myImageView = UIImageView()
        myImageView.image = AppConstants.Images.noConnection2
        return myImageView
    }()
    
    private lazy var secondBoyImageView: UIImageView = {
        let myImageView = UIImageView()
        myImageView.image = AppConstants.Images.noConnection1
        return myImageView
    }()
    
    private let reloadButton: CustomButton = {
        let myButton = CustomButton()
        myButton.setTitle("Переподключиться", for: .normal)
        myButton.addTarget(self,
                           action: #selector(reloadButtonTapped(gesture:)),
                           for: .touchUpInside)
        return myButton
    }()
    
    private let reloadTitle: UILabel = {
        let myLabel = UILabel()
        myLabel.font = AppFonts.titleLabelFont
        myLabel.text = "Не удалось подключиться к интернету\nМожете попробовать переподключиться"
        myLabel.numberOfLines = 0
        myLabel.textAlignment = .center
        return myLabel
    }()
    
    // MARK: - Properties
    var checkConnectionToInternet: (() -> Void)?
    var connectionEnabled: (() -> Void)?

    // Constaints для первого положения анимации
    private lazy var firstPlaceConstraint =
        self.topLeftPlaceFor(imageView: self.firstBoyImageView) +
        self.topRightPlaceFor(imageView: self.firstGirlImageView) +
        self.bottomRightPlaceFor(imageView: self.secondBoyImageView) +
        self.bottomLeftPlaceFor(imageView: self.secondGirlImageView)
    
    // Constaints для второго положения анимации
    private lazy var secondPlaceConstraint =
        self.topLeftPlaceFor(imageView: self.secondGirlImageView) +
        self.topRightPlaceFor(imageView: self.firstBoyImageView) +
        self.bottomRightPlaceFor(imageView: self.firstGirlImageView) +
        self.bottomLeftPlaceFor(imageView: self.secondBoyImageView)

    // Constaints для третьего положения анимации
    private lazy var thirdPlaceConstraint =
        self.topLeftPlaceFor(imageView: self.secondBoyImageView) +
        self.topRightPlaceFor(imageView: self.secondGirlImageView) +
        self.bottomRightPlaceFor(imageView: self.firstBoyImageView) +
        self.bottomLeftPlaceFor(imageView: self.firstGirlImageView)

    // Constaints для четвертого положения анимации
    private lazy var fourthPlaceConstraint =
        self.topLeftPlaceFor(imageView: self.firstGirlImageView) +
        self.topRightPlaceFor(imageView: self.secondBoyImageView) +
        self.bottomRightPlaceFor(imageView: self.secondGirlImageView) +
        self.bottomLeftPlaceFor(imageView: self.firstBoyImageView)
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupElements()
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Обрабокта нажатия на кнопку
    
    @objc private func reloadButtonTapped(gesture: UIGestureRecognizer) {
        self.reloadTitle.text = "Пробуем переподключиться..."
        self.checkConnectionToInternet?()
    }
}

// MARK: - INoConnectionView

extension NoConnectionView: INoConnectionView {
    func connection(isConnectionEnabled: Bool) {
        self.reloadButton.isUserInteractionEnabled = false
        self.animate {
            if isConnectionEnabled {
                self.connectionEnabled?()
            } else {
                self.reloadTitle.text = "Соединение отсутсвует"
            }
            self.reloadButton.isUserInteractionEnabled = true
        }
    }
}

// MARK: - UISetup

private extension NoConnectionView {
    func setupElements() {
        self.setupTopLeftImage()
        self.setupTopRightImage()
        self.setupBottomLeftImage()
        self.setupBottomRightImage()
        self.setupFirstLayout()
        self.setupReloadButton()
        self.setupReloadTitle()
    }

    func setupTopLeftImage() {
        self.addSubview(self.firstBoyImageView)
        self.firstBoyImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.firstBoyImageView.widthAnchor.constraint(
                equalToConstant: AppConstants.Sizes.noConnectionImagesSize.width),
            self.firstBoyImageView.heightAnchor.constraint(
                equalToConstant: AppConstants.Sizes.noConnectionImagesSize.height),
        ])
    }

    func setupTopRightImage() {
        self.addSubview(self.firstGirlImageView)
        self.firstGirlImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.firstGirlImageView.widthAnchor.constraint(
                equalToConstant: AppConstants.Sizes.noConnectionImagesSize.width),
            self.firstGirlImageView.heightAnchor.constraint(
                equalToConstant: AppConstants.Sizes.noConnectionImagesSize.height),
        ])
    }

    func setupBottomLeftImage() {
        self.addSubview(self.secondGirlImageView)
        self.secondGirlImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.secondGirlImageView.widthAnchor.constraint(
                equalToConstant: AppConstants.Sizes.noConnectionImagesSize.width),
            self.secondGirlImageView.heightAnchor.constraint(
                equalToConstant: AppConstants.Sizes.noConnectionImagesSize.height),
        ])
    }

    func setupBottomRightImage() {
        self.addSubview(self.secondBoyImageView)
        self.secondBoyImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.secondBoyImageView.widthAnchor.constraint(
                equalToConstant: AppConstants.Sizes.noConnectionImagesSize.width),
            self.secondBoyImageView.heightAnchor.constraint(
                equalToConstant: AppConstants.Sizes.noConnectionImagesSize.height),
        ])
    }


    func setupFirstLayout() {
        NSLayoutConstraint.activate(self.firstPlaceConstraint)
    }

    func setupReloadButton() {
        self.addSubview(self.reloadButton)
        self.reloadButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.reloadButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.reloadButton.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: AppConstants.Constraints.normalAnchorConstant),
            self.reloadButton.trailingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: -AppConstants.Constraints.normalAnchorConstant),
            self.reloadButton.heightAnchor.constraint(equalToConstant: AppConstants.Sizes.buttonsHeight),
        ])
    }

    func setupReloadTitle() {
        self.addSubview(self.reloadTitle)
        self.reloadTitle.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.reloadTitle.topAnchor.constraint(
                equalTo: self.reloadButton.bottomAnchor,
                constant: AppConstants.Constraints.normalAnchorConstant),
            self.reloadTitle.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: AppConstants.Constraints.normalAnchorConstant),
            self.reloadTitle.trailingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: -AppConstants.Constraints.normalAnchorConstant)
        ])
    }
}


private extension NoConnectionView {
    /// Возвращает массив Constraint-ов для верхнего левого места в анимации
    func topLeftPlaceFor(imageView: UIView) -> [NSLayoutConstraint] {
        return [imageView.leadingAnchor.constraint(
                    equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                    constant: AppConstants.Constraints.normalAnchorConstant),
                imageView.topAnchor.constraint(
                    equalTo: self.safeAreaLayoutGuide.topAnchor,
                    constant: AppConstants.Constraints.normalAnchorConstant)]
    }

    /// Возвращает массив Constraint-ов для верхнего правого места в анимации
    func topRightPlaceFor(imageView: UIView) -> [NSLayoutConstraint] {
        return [imageView.trailingAnchor.constraint(
                    equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                    constant: -AppConstants.Constraints.normalAnchorConstant),
                imageView.topAnchor.constraint(
                    equalTo: self.safeAreaLayoutGuide.topAnchor,
                    constant: AppConstants.Constraints.normalAnchorConstant)]
    }

    /// Возвращает массив Constraint-ов для нижнего левого места в анимации
    func bottomLeftPlaceFor(imageView: UIView) -> [NSLayoutConstraint] {
        return [imageView.leadingAnchor.constraint(
                    equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                    constant: AppConstants.Constraints.normalAnchorConstant),
                imageView.bottomAnchor.constraint(
                    equalTo: self.safeAreaLayoutGuide.bottomAnchor,
                    constant: -AppConstants.Constraints.normalAnchorConstant)]
    }

    /// Возвращает массив Constraint-ов для нижнего правого места в анимации
    func bottomRightPlaceFor(imageView: UIView) -> [NSLayoutConstraint] {
        return [imageView.trailingAnchor.constraint(
                    equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                    constant: -AppConstants.Constraints.normalAnchorConstant),
                imageView.bottomAnchor.constraint(
                    equalTo: self.safeAreaLayoutGuide.bottomAnchor,
                    constant: -AppConstants.Constraints.normalAnchorConstant)]
    }

    /// Анимация движения всех картинок по кругу во время проверки соединения с интернетом
    func animate(completion: @escaping (() -> Void)) {
        NSLayoutConstraint.deactivate(self.firstPlaceConstraint)
        NSLayoutConstraint.activate(self.secondPlaceConstraint)
        UIView.animate(withDuration: AppConstants.AnimationTime.noConnectionAnimationDuration) {
            self.layoutIfNeeded()
        }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + AppConstants.AnimationTime.noConnectionAnimationDuration) {
            NSLayoutConstraint.deactivate(self.secondPlaceConstraint)
            NSLayoutConstraint.activate(self.thirdPlaceConstraint)
            UIView.animate(withDuration: AppConstants.AnimationTime.noConnectionAnimationDuration) {
                self.layoutIfNeeded()
            }
        }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 2 * AppConstants.AnimationTime.noConnectionAnimationDuration) {
            NSLayoutConstraint.deactivate(self.thirdPlaceConstraint)
            NSLayoutConstraint.activate(self.fourthPlaceConstraint)
            UIView.animate(withDuration: AppConstants.AnimationTime.noConnectionAnimationDuration) {
                self.layoutIfNeeded()
            }
        }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 3 * AppConstants.AnimationTime.noConnectionAnimationDuration) {
            NSLayoutConstraint.deactivate(self.fourthPlaceConstraint)
            NSLayoutConstraint.activate(self.firstPlaceConstraint)
            UIView.animate(withDuration: AppConstants.AnimationTime.noConnectionAnimationDuration) {
                self.layoutIfNeeded()
            } completion: { (bool) in
                completion()
            }
        }
    }
}
