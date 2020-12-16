//
//  ProfileViewController.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/8/20.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    private var presenter: IProfilePresenter
    
    // MARK: - Views
    
    private let profileView = ProfileView()
    
    // MARK: - Жизненный цикл ViewController-а
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = profileView
        presenter.viewDidLoad(ui: self.profileView)
    }
    
    // MARK: - Init
    
    init(presenter: IProfilePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
