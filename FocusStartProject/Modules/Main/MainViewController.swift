//
//  MainViewController.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    private var presenter: IMainPresenter
    
    // MARK: - Views
    
    private let mainView = MainView()
    
    // MARK: - Жизненный цикл ViewController-а
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = mainView
        presenter.viewDidLoad(ui: self.mainView)
        self.title = "Главная"
    }
    
    // MARK: - Init
    
    init(presenter: IMainPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.setupSearchButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Настройка кнопки перехода на Searching VC на NavigationBar-е

private extension MainViewController {
    func setupSearchButton() {
        let searchButton = UIBarButtonItem(image: AppConstants.Images.searchImage,
                                           style: .plain,
                                           target: self,
                                           action: #selector(searchTapped))
        navigationItem.rightBarButtonItem = searchButton
    }
    
    @objc func searchTapped(gesture: UIGestureRecognizer) {
        self.presenter.searchButtonTapped()
    }
}
