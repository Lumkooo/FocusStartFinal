//
//  LaunchingView.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/18/20.
//

import UIKit
import AudioToolbox

protocol  ILaunchingView: class {
    var launched: (() -> Void)? { get set }

    func setupElements()
    func playLaunchingThing()
}

final class LaunchingView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let newSymbolShowingInterval: Double = 0.1
        static let roundedViewSize = CGSize(width: 2 * AppConstants.Sizes.cornerRadius,
                                            height: 2 * AppConstants.Sizes.cornerRadius)
        static let roundedViewAlpha: CGFloat = 0.9
        static let roundedViewScalingConstant: CGFloat = 100
        static let timeUntillMainLabelIsDisappearing: Double = 0.5
        static let timeUntillRoundedViewIsRemoved: Double = 0.75
        static let timeToTransormRoundedView: Double = 1
    }

    // MARK: - Properties

    var launched: (() -> Void)?
    private var appNameText: String = "Food App"

    // MARK: - Views

    private lazy var mainLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.textAlignment = .center
        myLabel.textColor = .white
        myLabel.font = AppFonts.launchingScreenTitleFont
        return myLabel
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupElements()
        self.backgroundColor = .black
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ILaunchingView

extension LaunchingView: ILaunchingView {
    func setupElements() {
        self.setupMainLabel()
    }

    func setupMainLabel() {
        self.addSubview(self.mainLabel)
        self.mainLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.mainLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                                                    constant: AppConstants.Constraints.normalAnchorConstant),
            self.mainLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                                                     constant: -AppConstants.Constraints.normalAnchorConstant),
            self.mainLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    func playLaunchingThing() {

        // "Печатаем" каждую букву с интервалом в 1 секунду
        for index in 1...self.appNameText.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index)*Constants.newSymbolShowingInterval) {
                self.mainLabel.text = String(self.appNameText.prefix(index))
                let symbol = self.appNameText[index-1]
                self.playTypingMusic(forSymbol: symbol)
            }
        }

        // Анимированное окошко, которое внешне как бы убирает черный экран и показывает главный экран приложения
        DispatchQueue.main.asyncAfter(deadline: .now() + 11*Constants.newSymbolShowingInterval) {
            self.animationForDismissingView()
        }

        // По сути dismiss этой view и всего LaunchingScreen-а
        DispatchQueue.main.asyncAfter(deadline: .now() + 15*Constants.newSymbolShowingInterval) {
            self.launched?()
        }
    }
}

// MARK: - UISetup

private extension LaunchingView {
    func playTypingMusic(forSymbol symbol: Character) {
        if symbol == " " {
            // Воспроизведение звука нажатия на пробел на клавиатуре
            AudioServicesPlaySystemSound (1156)
        } else {
            // Воспроизведение звука нажатия на символ на клавиатуре
            AudioServicesPlaySystemSound (1104)
        }
    }

    func animationForDismissingView() {
        let roundedView = UIView()
        roundedView.layer.cornerRadius = AppConstants.Sizes.cornerRadius
        roundedView.backgroundColor = .white
        roundedView.alpha = Constants.roundedViewAlpha

        self.addSubview(roundedView)
        roundedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            roundedView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            roundedView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            roundedView.heightAnchor.constraint(equalToConstant: Constants.roundedViewSize.height),
            roundedView.widthAnchor.constraint(equalToConstant: Constants.roundedViewSize.width),

        ])
        UIView.animate(withDuration: Constants.timeUntillMainLabelIsDisappearing) {
            self.mainLabel.alpha = 0
        } completion: { (bool) in
            self.mainLabel.removeFromSuperview()
        }
        UIView.animate(withDuration: Constants.timeToTransormRoundedView) {
            roundedView.transform = CGAffineTransform(scaleX: Constants.roundedViewScalingConstant,
                                                      y: Constants.roundedViewScalingConstant)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+Constants.timeUntillRoundedViewIsRemoved) {
            roundedView.removeFromSuperview()
        }
    }
}
