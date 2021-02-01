//
//  RegisterViewController.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/8/20.
//

import UIKit

final class RegisterViewController: UIViewController {
    
    // MARK: - Properties
    
    private var presenter: IRegisterPresenter
    
    // MARK: - Views
    
    private let registerView = RegisterView()
    
    // MARK: - Жизненный цикл ViewController-а
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = registerView
        presenter.viewDidLoad(ui: self.registerView)
    }
    
    // MARK: - Init
    
    init(presenter: IRegisterPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
