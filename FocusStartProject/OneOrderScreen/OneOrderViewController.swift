//
//  OneOrderViewController.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/12/20.
//

import UIKit

final class OneOrderViewContorller: UIViewController {

    // MARK: - Properties

    var presenter: IOneOrderPresenter

    // MARK: - Views

    let oneOrderView = OneOrderView()

    // MARK: - Жизненный цикл ViewController-а

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = oneOrderView
        self.presenter.viewDidLoad(ui: self.oneOrderView)
    }

    // MARK: - Init

    init(presenter: IOneOrderPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }}
