//
//  NoConnectionViewController.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/18/20.
//

import UIKit

final class NoConnectionViewController: UIViewController {

    // MARK: - Views

    private var noConnectionView = NoConnectionView()

    // MARK: - Properties

    private var presenter: INoConnectionPresenter


    // MARK: - Init

    init(presenter: INoConnectionPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - VC Lyfe Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = noConnectionView
        self.presenter.viewDidLoad(ui: self.noConnectionView)
    }
}

