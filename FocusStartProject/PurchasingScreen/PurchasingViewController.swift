//
//  PurchasingViewController.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/9/20.
//

import UIKit

final class PurchasingViewController: UIViewController {

    // MARK: - Properties

    var presenter: IPurchasingPresenter

    // MARK: - Views

    let purchasingView = PurchasingView()

    // MARK: - Жизненный цикл ViewController-а

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = purchasingView
        self.presenter.viewDidLoad(ui: self.purchasingView)
        self.title = "Продолжение покупки"
    }

    // MARK: - Init

    init(presenter: IPurchasingPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
