//
//  FinalPurchasingViewController.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/10/20.
//

import UIKit

final class FinalPurchasingViewController: UIViewController {
    
    // MARK: - Views
    
    private let infoLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.font = AppFonts.titleLabelFont
        myLabel.numberOfLines = 0
        myLabel.text = "Спасибо за покупку!\nЕсли есть какие-то вопросы, обращайтесь по номеру телефона:\n +7 XXX XXX XX XX"
        myLabel.textAlignment = .center
        return myLabel
    }()
    
    private let orderButton: CustomButton = {
        let myButton = CustomButton()
        myButton.addTarget(self,
                           action: #selector(orderButtonTapped(gesture:)),
                           for: .touchUpInside)
        myButton.setTitle("Хорошо", for: .normal)
        return myButton
    }()
    
    // MARK: - Жизненный цикл ViewController-а
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.setupElements()
    }
    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Обработка нажатия на кнопку
    
    @objc func orderButtonTapped(gesture: UIGestureRecognizer) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - UISetup

private extension FinalPurchasingViewController {
    func setupElements() {
        self.setupTopInfoLabel()
        self.setupOrderButton()
    }
    
    func setupTopInfoLabel() {
        self.view.addSubview(self.infoLabel)
        self.infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.infoLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,
                                                    constant: AppConstants.Constraints.normalAnchorConstant),
            self.infoLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,
                                                     constant: -AppConstants.Constraints.normalAnchorConstant),
            self.infoLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -AppConstants.Constraints.normalAnchorConstant)
        ])
    }
    
    func setupOrderButton() {
        self.view.addSubview(self.orderButton)
        self.orderButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.orderButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,
                                                      constant: AppConstants.Constraints.normalAnchorConstant),
            self.orderButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,
                                                       constant: -AppConstants.Constraints.normalAnchorConstant),
            self.orderButton.topAnchor.constraint(equalTo: self.infoLabel.bottomAnchor,
                                                  constant: AppConstants.Constraints.normalAnchorConstant),
            self.orderButton.heightAnchor.constraint(equalToConstant: AppConstants.Sizes.buttonsHeight)
        ])
    }
}

