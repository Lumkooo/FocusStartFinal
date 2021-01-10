//
//  PurchasingViewController.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/9/20.
//

import UIKit

final class PurchasingViewController: UIViewController {
    
    // MARK: - Properties
    
    private var presenter: IPurchasingPresenter
    
    // MARK: - Views
    
    private let purchasingView = PurchasingView()
    
    // MARK: - Жизненный цикл ViewController-а
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = purchasingView
        self.presenter.viewDidLoad(ui: self.purchasingView)
        self.title = "Продолжение покупки"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.presenter.viewWillAppear()
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
