//
//  RegisterView.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/8/20.
//

import UIKit

protocol IRegisterView: class {
    var textFieldsAlert: ((String) -> Void)? { get set }
    var doneTapped:((LoginEntitie)-> Void)? { get set }
}

final class RegisterView: UIView {

    // MARK: - Views

    private let topLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.text = "Регистрация"
        myLabel.font = AppFonts.titleLabelFont
        myLabel.textAlignment = .center
        return myLabel
    }()

    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.textContentType = .username
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .continue
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Пароль"
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .continue
        return textField
    }()

    private let repeatPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Повторите пароль"
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .done
        return textField
    }()

    private let doneButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("Готово", for: .normal)
        button.addTarget(self, action: #selector(doneButtonTapped(gesture:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let securePasswordButton: UIButton = {
        let button = UIButton()
        button.setImage(AppConstants.Images.showPasswordImage, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(securePasswordButtonTapped(gesture:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()


    // MARK: - Properties

    private var isKeyboardShowing = false
    private var doneButtonBottomAnchor:NSLayoutConstraint!
    private var doneButtonBottomAnchorWithKeyboard:NSLayoutConstraint!
    var doneTapped:((LoginEntitie)-> Void)?
    var textFieldsAlert: ((String) -> Void)?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        setupElements()
        setupNotifications()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func doneButtonTapped(gesture:UIGestureRecognizer) {
        self.checkFilledTextFields()
    }

    @objc private func securePasswordButtonTapped(gesture:UIGestureRecognizer) {
        let isSecure = self.passwordTextField.isSecureTextEntry
        self.passwordTextField.isSecureTextEntry = !self.passwordTextField.isSecureTextEntry
        self.repeatPasswordTextField.isSecureTextEntry = !self.repeatPasswordTextField.isSecureTextEntry
        if isSecure{
            self.securePasswordButton.setImage(AppConstants.Images.hidePasswordImage, for: .normal)
        } else {
            self.securePasswordButton.setImage(AppConstants.Images.showPasswordImage, for: .normal)
        }
    }
}

// MARK: - Установка constraint-ов для элементов и приватные методы

private extension RegisterView {
    func setupElements() {
        self.hideKeyboardWhenTappedAround()
        self.setupDoneButtonAnchor()
        self.setupTopLabel()
        self.setupEmailTextField()
        self.setupPasswordTextField()
        self.setupRepeatPasswordTextField()
        self.setupDoneButton()
        self.setupTextFieldsDelegate()
    }

    func setupTextFieldsDelegate() {
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.repeatPasswordTextField.delegate = self
    }

    func setupDoneButtonAnchor() {
        self.doneButtonBottomAnchor = self.doneButton.bottomAnchor.constraint(
            equalTo: self.safeAreaLayoutGuide.bottomAnchor,
            constant: -AppConstants.Constraints.halfNormalAnchorConstaint)
    }

    func setupTopLabel() {
        self.addSubview(self.topLabel)
        self.topLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.topLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                   constant: AppConstants.Constraints.normalAnchorConstant),
            self.topLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor,
                                               constant: AppConstants.Constraints.normalAnchorConstant),
            self.topLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                    constant: -AppConstants.Constraints.normalAnchorConstant),
        ])
    }

    func setupEmailTextField() {
        self.addSubview(self.emailTextField)
        self.emailTextField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.emailTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                         constant: AppConstants.Constraints.normalAnchorConstant),
            self.emailTextField.topAnchor.constraint(equalTo: self.topLabel.bottomAnchor,
                                                     constant: AppConstants.Constraints.normalAnchorConstant),
            self.emailTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                          constant: -AppConstants.Constraints.normalAnchorConstant),
        ])
    }

    func setupRepeatPasswordTextField() {
        self.addSubview(self.repeatPasswordTextField)
        self.repeatPasswordTextField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.repeatPasswordTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                                  constant: AppConstants.Constraints.normalAnchorConstant),
            self.repeatPasswordTextField.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor,
                                                              constant: AppConstants.Constraints.normalAnchorConstant),
            self.repeatPasswordTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                                   constant: -AppConstants.Constraints.normalAnchorConstant),
        ])
    }

    func setupPasswordTextField() {
        self.addSubview(self.passwordTextField)
        self.passwordTextField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.passwordTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                            constant: AppConstants.Constraints.normalAnchorConstant),
            self.passwordTextField.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor,
                                                        constant: AppConstants.Constraints.normalAnchorConstant),
            self.passwordTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                             constant: -AppConstants.Constraints.normalAnchorConstant),
        ])
        self.setupSecurePasswordButton()
    }

    func setupDoneButton() {
        self.addSubview(self.doneButton)
        self.doneButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.doneButton.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                     constant: AppConstants.Constraints.normalAnchorConstant),
            self.doneButtonBottomAnchor,
            self.doneButton.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                      constant: -AppConstants.Constraints.normalAnchorConstant),
            self.doneButton.heightAnchor.constraint(equalToConstant: AppConstants.Sizes.buttonsHeight)
        ])
    }

    func setupSecurePasswordButton() {
        self.addSubview(self.securePasswordButton)
        self.securePasswordButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.securePasswordButton.trailingAnchor.constraint(equalTo: self.passwordTextField.trailingAnchor,
                                                                constant: -AppConstants.Constraints.quarterNormalAnchorConstaint),
            self.securePasswordButton.topAnchor.constraint(equalTo: self.passwordTextField.topAnchor),
            self.securePasswordButton.bottomAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor),
        ])
    }

    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if !self.isKeyboardShowing {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                let anchorConstant = keyboardHeight - self.safeAreaInsets.bottom
                self.doneButtonBottomAnchorWithKeyboard = self.doneButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -anchorConstant)
                NSLayoutConstraint.deactivate([self.doneButtonBottomAnchor])
                NSLayoutConstraint.activate([self.doneButtonBottomAnchorWithKeyboard])
                UIView.animate(withDuration: AppConstants.AnimationTime.keyboardAnimationDuration) {
                    self.layoutIfNeeded()
                }
                self.isKeyboardShowing = true
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.isKeyboardShowing {
            NSLayoutConstraint.deactivate([self.doneButtonBottomAnchorWithKeyboard])
            NSLayoutConstraint.activate([self.doneButtonBottomAnchor])
            UIView.animate(withDuration: AppConstants.AnimationTime.keyboardAnimationDuration) {
                self.layoutIfNeeded()
            }
            self.isKeyboardShowing = false
        }
    }

    // Убираем клавиатуру, когда нажимаем куда-либо
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        self.endEditing(true)
    }

    func checkFilledTextFields() {
        guard let email = self.emailTextField.text ,
              !email.isEmpty else {
            // Так делать не надо =)
            self.textFieldsAlert?("Необходимо заполнить поле email")
            return
        }
        guard let password = self.passwordTextField.text ,
              !password.isEmpty else {
            self.textFieldsAlert?("Необходимо заполнить поле с паролем")
            return
        }

        guard let repeatedPassword = self.repeatPasswordTextField.text ,
              !repeatedPassword.isEmpty else {
            self.textFieldsAlert?("Необходимо заполнить второе поле с подтверждением пароля")
            return
        }

        guard password == repeatedPassword else {
            self.textFieldsAlert?("Пароли должны совпадать")
            return
        }

        let loginEntitie = LoginEntitie(email: email,
                                        password: password)
        doneTapped?(loginEntitie)
        dismissKeyboard()
    }
}

// MARK: - UITextFieldDelegate

extension RegisterView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            self.textFieldShouldReturnForEmailTF()
        } else if textField == self.passwordTextField {
            self.textFieldShouldReturnForPasswordTF()
        }  else if textField == self.repeatPasswordTextField {
            self.textFieldShouldReturnForRepeatPasswordTF()
        }
        return true
    }

    fileprivate func textFieldShouldReturnForEmailTF() {
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.becomeFirstResponder()
    }

    fileprivate func textFieldShouldReturnForPasswordTF() {
        self.passwordTextField.resignFirstResponder()
        self.repeatPasswordTextField.becomeFirstResponder()
    }

    fileprivate func textFieldShouldReturnForRepeatPasswordTF() {
        self.repeatPasswordTextField.resignFirstResponder()
        self.checkFilledTextFields()
    }

    // установка textField.isSecureTextEntry = true
    // Потому что если ставить isSecureTextEntry = true при инициализациии,
    // то почему-то срабатывает autoFill на textField-ах
    // и не дает что-либо делать с textField-ами
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == self.passwordTextField && !self.passwordTextField.isSecureTextEntry) ||
            (textField == self.repeatPasswordTextField && !self.repeatPasswordTextField.isSecureTextEntry){
            self.passwordTextField.isSecureTextEntry = true
            self.repeatPasswordTextField.isSecureTextEntry = true
        }
        return true
    }
}

// MARK: - IRegisterView

extension RegisterView: IRegisterView {

}
