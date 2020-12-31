//
//  LoginViewController.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/8/20.
//

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private var presenter: ILoginPresenter
    
    // MARK: - Views
    
    private let loginView = LoginView()
    
    // MARK: - Жизненный цикл ViewController-а
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = loginView
        presenter.viewDidLoad(ui: self.loginView)
    }
    
    // MARK: - Init
    
    init(presenter: ILoginPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
