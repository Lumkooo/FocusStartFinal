//
//  MainViewController.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import UIKit

final class MainViewController: UIViewController {

    // MARK: - Properties

    var presenter: IMainPresenter

    // MARK: - Views

    let mainView = MainView()

    // MARK: - Жизненный цикл ViewController-а

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = mainView
        presenter.viewDidLoad(ui: self.mainView)
    }

    // MARK: - Init

    init(presenter: IMainPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
