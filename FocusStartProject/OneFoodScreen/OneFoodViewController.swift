//
//  OneFoodViewController.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/8/20.
//

import UIKit

final class OneFoodViewController: UIViewController {

    // MARK: - Properties

    var presenter: IOneFoodPresenter

    // MARK: - Views

    let oneFoodView = OneFoodView()

    // MARK: - Жизненный цикл ViewController-а

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = oneFoodView
        presenter.viewDidLoad(ui: self.oneFoodView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.oneFoodView.animatedViewPresentation()
    }

    // MARK: - Init

    init(presenter: IOneFoodPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
