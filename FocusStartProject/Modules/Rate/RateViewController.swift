//
//  RateViewController.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/26/20.
//

import UIKit

final class RateViewController: UIViewController {

    // MARK: - Views

    private var rateView = RateView()

    // MARK: - Properties

    private var presenter: IRatePresenter


    // MARK: - Init

    init(presenter: IRatePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - VC Lyfe Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = self.rateView
        self.presenter.viewDidLoad(ui: self.rateView)
    }
}
