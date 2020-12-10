//
//  ProfileView.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/8/20.
//

import UIKit

protocol IProfileView: class {
    var registerTapped:(()-> Void)? { get set }
    var loginTapped:(()-> Void)? { get set }
    var logoutTapped: (() -> Void)? { get set }

    func setupViewForAuthorizedUser(userEmail: String)
    func setupViewForUnauthorizedUser()
}
// TODO: - Animated View вынести в отдельный класс AnimatedView
// и после просто вызывать это View, все настройки вынести в отдельный класс
final class ProfileView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let anchorConstant:CGFloat = 16
        static let topLabelAnchorConstant:CGFloat = 48
        static let buttonHeight: CGFloat = 50
        static let emailImage = UIImage(named: "emailImage")
        static let animationViewAnimationConstant: CGFloat = 200
        static let animationViewHeight: CGFloat = 130
        static let animationViewEmailButtonSize: CGSize = CGSize(width: 75, height: 75)
        static let animationViewCloseButtonSize: CGSize = CGSize(width: 40, height: 40)
        static let animatedButtonCornerRadius: CGFloat = 7
        static let animatedViewBackgroundViewAlpha: CGFloat = 0.25
        static let animationTime: Double = 0.5
    }

    // MARK: - Fonts

    private enum Fonts {
        static let topLabelFont = UIFont.systemFont(ofSize: 20, weight: .light)
    }

    // MARK: - authorizedView

    private lazy var authorizedView: UIView = {
        let myView = UIView()
        return myView
    }()

    private lazy var authorizedTopTitle: UILabel = {
        let myLabel = UILabel()
        myLabel.textAlignment = .center
        myLabel.numberOfLines = 3
        myLabel.text = "Вы вошли как:"
        myLabel.font = Fonts.topLabelFont
        return myLabel
    }()

    private lazy var authorizedRecordsListTitle: UILabel = {
        let myLabel = UILabel()
        myLabel.text = "Список заказов:"
        myLabel.font = Fonts.topLabelFont
        return myLabel
    }()


    private lazy var logoutButton: CustomButton = {
        let myButton = CustomButton()
        myButton.setTitle("Выйти из аккаунта", for: .normal)
        myButton.addTarget(self, action: #selector(logoutButtonTapped(gesture:)), for: .touchUpInside)
        return myButton
    }()

    // MARK: - unauthorizedView

    private lazy var unauthorizedView: UIView = {
        let myView = UIView()
        return myView
    }()

    private lazy var unauthorizedTopLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.numberOfLines = 0
        myLabel.font = Fonts.topLabelFont
        myLabel.textAlignment = .center
        myLabel.text = "Вы не вошли в свой аккаунт\nСоздайте аккаунт или войдите в уже существующий"
        return myLabel
    }()

    private lazy var registerButton: CustomButton = {
        let myButton = CustomButton()
        myButton.setTitle("Зарегестрироваться", for: .normal)
        myButton.addTarget(self, action: #selector(registerButtonTapped(gesture:)), for: .touchUpInside)
        return myButton
    }()

    private lazy var loginButton: CustomButton = {
        let myButton = CustomButton()
        myButton.setTitle("Войти в профиль", for: .normal)
        myButton.addTarget(self, action: #selector(loginButtonTapped(gesture:)), for: .touchUpInside)
        return myButton
    }()

    // MARK: - AnimatedView

    private lazy var animatedViewBackgroundView: UIView = {
        let myView = UIView()
        myView.backgroundColor = UIColor.black.withAlphaComponent(0)
        return myView
    }()

    private lazy var animatedView: UIView = {
        let myView = UIView()
        myView.layer.cornerRadius = Constants.animatedButtonCornerRadius
        myView.backgroundColor = .white
        return myView
    }()

    private lazy var animatedViewTopLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.text = "С помощью:"
        myLabel.font = Fonts.topLabelFont
        return myLabel
    }()

    private lazy var animatedViewEmailButton: UIButton = {
        let myButton = UIButton()
        myButton.setImage(Constants.emailImage, for: .normal)
        return myButton
    }()

    private lazy var closeAnimatedViewButton: CustomCloseButton = {
        let myButton = CustomCloseButton()
        myButton.addTarget(self, action: #selector(closeAnimatedViewButtonTapped(gesture:)), for: .touchUpInside)
        return myButton
    }()

    // MARK: - Properties

    var registerTapped:(()-> Void)?
    var loginTapped:(()-> Void)?
    var logoutTapped: (() -> Void)?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Настройка AthorizedScreen-а (Экрана авторизованного пользователя)

private extension ProfileView {
    func setupAthorizedScreen() {
        self.setupAuthorizedView()
        self.setupAuthorizedTopTitle()
        self.setupAuthorizedRecordsListTitle()
        self.setupLogoutButton()
    }

    func setupAuthorizedView() {
        self.addSubview(self.authorizedView)
        self.authorizedView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.authorizedView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.authorizedView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            self.authorizedView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            self.authorizedView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    func setupAuthorizedTopTitle() {
        self.authorizedView.addSubview(self.authorizedTopTitle)
        self.authorizedTopTitle.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.authorizedTopTitle.topAnchor.constraint(equalTo: self.authorizedView.topAnchor,
                                                      constant: Constants.anchorConstant),
            self.authorizedTopTitle.leadingAnchor.constraint(equalTo: self.authorizedView.leadingAnchor,
                                                  constant: Constants.anchorConstant),
            self.authorizedTopTitle.trailingAnchor.constraint(equalTo: self.authorizedView.trailingAnchor,
                                                  constant: -Constants.anchorConstant)
        ])
    }

    func setupAuthorizedRecordsListTitle() {
        self.authorizedView.addSubview(self.authorizedRecordsListTitle)
        self.authorizedRecordsListTitle.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.authorizedRecordsListTitle.topAnchor.constraint(equalTo: self.authorizedTopTitle.bottomAnchor,
                                                         constant: Constants.anchorConstant),
            self.authorizedRecordsListTitle.leadingAnchor.constraint(equalTo: self.authorizedView.leadingAnchor,
                                                             constant: Constants.anchorConstant),
            self.authorizedRecordsListTitle.trailingAnchor.constraint(equalTo: self.authorizedView.trailingAnchor,
                                                              constant: -Constants.anchorConstant)
        ])
    }

    func setupLogoutButton() {
        self.authorizedView.addSubview(self.logoutButton)
        self.logoutButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.logoutButton.bottomAnchor.constraint(equalTo: self.authorizedView.bottomAnchor,
                                                      constant: -Constants.anchorConstant),
            self.logoutButton.leadingAnchor.constraint(equalTo: self.authorizedView.leadingAnchor,
                                                  constant: Constants.anchorConstant),
            self.logoutButton.trailingAnchor.constraint(equalTo: self.authorizedView.trailingAnchor,
                                                  constant: -Constants.anchorConstant),
            self.logoutButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
    }

    @objc private func logoutButtonTapped(gesture:UIGestureRecognizer) {
        self.logoutTapped?()
    }
}

// MARK: - Настройка UnathorizedScreen-а (Экрана с кнопками регистрации и авторизации)

private extension ProfileView {
    func setupUnathorizedScreen() {
        self.setupUnathorizedView()
        self.setupLoginButton()
        self.setupSignInButton()
        self.setupUnauthorizedTopLabel()
    }

    func setupUnathorizedView() {
        self.addSubview(self.unauthorizedView)
        self.unauthorizedView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.unauthorizedView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.unauthorizedView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            self.unauthorizedView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            self.unauthorizedView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    func setupLoginButton() {
        self.unauthorizedView.addSubview(self.loginButton)
        self.loginButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.loginButton.topAnchor.constraint(equalTo: self.unauthorizedView.centerYAnchor,
                                                  constant: Constants.anchorConstant),
            self.loginButton.leadingAnchor.constraint(equalTo: self.unauthorizedView.leadingAnchor,
                                                  constant: Constants.anchorConstant),
            self.loginButton.trailingAnchor.constraint(equalTo: self.unauthorizedView.trailingAnchor,
                                                  constant: -Constants.anchorConstant),
            self.loginButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
    }

    func setupSignInButton() {
        self.unauthorizedView.addSubview(self.registerButton)
        self.registerButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.registerButton.bottomAnchor.constraint(equalTo: self.unauthorizedView.centerYAnchor,
                                                  constant: -Constants.anchorConstant),
            self.registerButton.leadingAnchor.constraint(equalTo: self.unauthorizedView.leadingAnchor,
                                                  constant: Constants.anchorConstant),
            self.registerButton.trailingAnchor.constraint(equalTo: self.unauthorizedView.trailingAnchor,
                                                  constant: -Constants.anchorConstant),
            self.registerButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
    }

    func setupUnauthorizedTopLabel() {
        self.addSubview(self.unauthorizedTopLabel)
        self.unauthorizedTopLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.unauthorizedTopLabel.topAnchor.constraint(equalTo: self.unauthorizedView.topAnchor,
                                                  constant: Constants.topLabelAnchorConstant),
            self.unauthorizedTopLabel.leadingAnchor.constraint(equalTo: self.unauthorizedView.leadingAnchor,
                                                  constant: Constants.anchorConstant),
            self.unauthorizedTopLabel.trailingAnchor.constraint(equalTo: self.unauthorizedView.trailingAnchor,
                                                  constant: -Constants.anchorConstant)
        ])
    }

    @objc private func registerButtonTapped(gesture:UIGestureRecognizer) {
        self.showAnimatedRegisterView(withActionForButton: #selector(registerWithEmail(gesture:)))
    }

    @objc private func registerWithEmail(gesture:UIGestureRecognizer) {
        self.closeAnimatedRegisterView()
        self.registerTapped?()
    }

    @objc private func loginButtonTapped(gesture:UIGestureRecognizer) {
        self.showAnimatedRegisterView(withActionForButton: #selector(loginWithEmail(gesture:)))
    }

    @objc private func loginWithEmail(gesture:UIGestureRecognizer) {
        self.closeAnimatedRegisterView()
        self.loginTapped?()
    }
}


// MARK: - IProfileView

extension ProfileView: IProfileView {
    func setupViewForAuthorizedUser(userEmail: String) {
        self.subviews.forEach { $0.removeFromSuperview() }
        self.setupAthorizedScreen()
        self.authorizedTopTitle.text = "Вы вошли как:\n\(userEmail)"
        // MARK: - Загрузка записей из БД
    }

    func setupViewForUnauthorizedUser() {
        self.subviews.forEach { $0.removeFromSuperview() }
        self.setupUnathorizedScreen()
    }
}

// MARK: - Настройка AnimatedRegisterView

private extension ProfileView {

    @objc func closeAnimatedViewButtonTapped(gesture: UIGestureRecognizer) {
        self.closeAnimatedRegisterView()
    }

    func closeAnimatedRegisterView() {
        UIView.animate(withDuration: Constants.animationTime) {
            self.animatedView.transform = CGAffineTransform(translationX: 0,
                                                            y: Constants.animationViewAnimationConstant)
            self.animatedViewBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0)
        } completion: { (bool) in
            self.animatedViewBackgroundView.removeFromSuperview()
        }
    }

    func showAnimatedRegisterView(withActionForButton action: Selector){
        self.animatedViewEmailButton.removeTarget(self, action: nil, for: .touchUpInside)
        self.animatedViewEmailButton.addTarget(self, action: action, for: .touchUpInside)
        self.setupAnimatedViewBackgroundView()
        self.setupAnimatedView()
        UIView.animate(withDuration: Constants.animationTime) {
            self.animatedView.transform = CGAffineTransform(translationX: 0,
                                                            y: -Constants.animationViewAnimationConstant)
            self.animatedViewBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(Constants.animatedViewBackgroundViewAlpha)
        }
    }

    func setupAnimatedViewBackgroundView() {
        self.addSubview(self.animatedViewBackgroundView)
        self.animatedViewBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.animatedViewBackgroundView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            self.animatedViewBackgroundView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            self.animatedViewBackgroundView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            self.animatedViewBackgroundView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor)
        ])
    }

    func setupAnimatedView() {
        self.animatedViewBackgroundView.addSubview(self.animatedView)
        self.animatedView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.animatedView.leadingAnchor.constraint(equalTo: self.animatedViewBackgroundView.leadingAnchor),
            self.animatedView.trailingAnchor.constraint(equalTo: self.animatedViewBackgroundView.trailingAnchor),
            self.animatedView.bottomAnchor.constraint(equalTo: self.animatedViewBackgroundView.bottomAnchor,
                                                      constant: Constants.animationViewAnimationConstant),
            self.animatedView.heightAnchor.constraint(equalToConstant: Constants.animationViewHeight)
        ])

        self.setupAnimatedViewTopLabel()
        self.setupAnimatedViewEmailButton()
        self.setupCloseAnimatedViewButton()
    }

    func setupAnimatedViewTopLabel() {
        self.animatedView.addSubview(self.animatedViewTopLabel)
        self.animatedViewTopLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.animatedViewTopLabel.centerXAnchor.constraint(equalTo: self.animatedView.centerXAnchor),
            self.animatedViewTopLabel.topAnchor.constraint(equalTo: self.animatedView.topAnchor,
                                                           constant: Constants.anchorConstant)
        ])
    }

    func setupAnimatedViewEmailButton() {
        self.animatedView.addSubview(self.animatedViewEmailButton)
        self.animatedViewEmailButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.animatedViewEmailButton.centerXAnchor.constraint(equalTo: self.animatedView.centerXAnchor),
            self.animatedViewEmailButton.bottomAnchor.constraint(equalTo: self.animatedView.bottomAnchor,
                                                                 constant: -Constants.anchorConstant),
            self.animatedViewEmailButton.heightAnchor.constraint(equalToConstant: Constants.animationViewEmailButtonSize.height),
            self.animatedViewEmailButton.widthAnchor.constraint(equalToConstant: Constants.animationViewEmailButtonSize.width)
        ])
    }

    func setupCloseAnimatedViewButton() {
        self.animatedView.addSubview(self.closeAnimatedViewButton)
        self.closeAnimatedViewButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.closeAnimatedViewButton.trailingAnchor.constraint(equalTo: self.animatedView.trailingAnchor,
                                                                   constant: -Constants.anchorConstant),
            self.closeAnimatedViewButton.topAnchor.constraint(equalTo: self.animatedView.topAnchor,
                                                              constant: Constants.anchorConstant),
            self.closeAnimatedViewButton.heightAnchor.constraint(equalToConstant: Constants.animationViewCloseButtonSize.height),
            self.closeAnimatedViewButton.widthAnchor.constraint(equalToConstant: Constants.animationViewCloseButtonSize.width)
        ])
    }
}
