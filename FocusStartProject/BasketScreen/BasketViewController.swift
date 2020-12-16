//
//  BasketViewController.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/8/20.
//

import UIKit

final class BasketViewController: UIViewController {
    
    // MARK: - Properties
    
    private var presenter: IBasketPresenter
    
    // MARK: - Views
    
    private let basketView = BasketView()
    
    // MARK: - Жизненный цикл ViewController-а
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = basketView
        self.presenter.viewDidLoad(ui: self.basketView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.presenter.viewWillAppear()
    }
    
    // MARK: - Init
    
    init(presenter: IBasketPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
