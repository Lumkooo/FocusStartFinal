//
//  MenuViewController.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/8/20.
//

import UIKit

final class MenuViewController: UIViewController {

    // MARK: - Properties

    private var presenter: IMenuPresenter

    // MARK: - Views

    private let menuView = MenuView()

    // MARK: - Жизненный цикл ViewController-а

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = menuView
        presenter.viewDidLoad(ui: self.menuView)
        self.title = "Меню"
    }

    // MARK: - Init

    init(presenter: IMenuPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
