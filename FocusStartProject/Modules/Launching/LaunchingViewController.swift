//
//  LaunchingViewController.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/18/20.
//

import UIKit


final class LaunchingViewController: UIViewController {

    // MARK: - Views

    private var launchingView = LaunchingView()

    // MARK: - Properties

    private var presenter: ILaunchingPresenter

    // MARK: - Init

    init(presenter: ILaunchingPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - VC Lyfe Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = launchingView
        self.presenter.viewDidLoad(ui: self.launchingView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.presenter.viewDidAppear()
    }
}
