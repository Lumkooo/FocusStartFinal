//
//  SearchingViewController.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/14/20.
//

import UIKit

final class SearchingViewController: UIViewController {

    // MARK: - Properties

    private var presenter: ISearchingPresenter
    private var searchBarDelegate: SearchingScreenSearchBarDelegate?

    // MARK: - Views

    private let searchingView = SearchingView()

    private let searchController: UISearchController = {
        let mySearchController = UISearchController(searchResultsController: nil)
        mySearchController.searchBar.sizeToFit()
        // Все категории не входили, поэтому оставим некоторые
        // фаст-фуд выбрал опираясь на то, что на Яндекс.Еда чаще всего заказывают
        // продукты, относящиеся к фаст-фуду
        mySearchController.searchBar.scopeButtonTitles = ["Все", "Фаст-фуд", "Кофейня"]
        mySearchController.searchBar.showsScopeBar = true
        return mySearchController
    }()

    // MARK: - Жизненный цикл ViewController-а

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = self.searchingView
        self.presenter.viewDidLoad(ui: self.searchingView)
        self.setupSearchController()
    }

    // MARK: - Init

    init(presenter: ISearchingPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSearchController() {
        searchBarDelegate = SearchingScreenSearchBarDelegate(withDelegate: self)
        self.searchController.searchBar.delegate = searchBarDelegate
        self.navigationItem.titleView = self.searchController.searchBar
        searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.searchBarStyle = UISearchBar.Style.minimal
        self.definesPresentationContext = true
    }
}

// MARK: - ISearchingScreenSearchBarDelegate

extension SearchingViewController: ISearchingScreenSearchBarDelegate {
    func textSearching(text: String, category: String) {
        self.presenter.textSearching(text: text, category: category)
    }
}
