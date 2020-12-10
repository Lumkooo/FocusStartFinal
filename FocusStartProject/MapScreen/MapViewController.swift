//
//  MapViewController.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/8/20.
//

import UIKit

final class MapViewController: UIViewController {

    // MARK: - Properties

    var presenter: IMapPresenter

    // MARK: - Views

    let mapView = MapView()

    // MARK: - Жизненный цикл ViewController-а

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = mapView
        presenter.viewDidLoad(ui: self.mapView)
        self.title = "Заведения на карте"

    }

    // MARK: - Init

    init(presenter: IMapPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
