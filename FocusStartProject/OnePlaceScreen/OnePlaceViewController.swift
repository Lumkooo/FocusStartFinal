//
//  OnePlaceViewController.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import UIKit

final class OnePlaceViewController: UIViewController {
    
    // MARK: - Properties
    
    private var presenter: IOnePlacePresenter
    
    // MARK: - Views
    
    private let onePlaceView = OnePlaceView()
    
    // MARK: - Жизненный цикл ViewController-а
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = onePlaceView
        presenter.viewDidLoad(ui: self.onePlaceView)
        self.title = "Одно заведение"
    }
    
    // MARK: - Init
    
    init(presenter: IOnePlacePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
