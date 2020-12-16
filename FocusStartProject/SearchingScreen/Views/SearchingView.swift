//
//  SearchingView.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/14/20.
//

import UIKit


protocol ISearchingView: class {
    var cellTapped: ((IndexPath) -> Void)? { get set }

    func setupTableView(withPlace places: [Place])
}

final class SearchingView: UIView {

    // MARK: - Views

    private let tableView: UITableView = {
        let myTableView = UITableView()
        myTableView.register(UITableViewCell.self,
                             forCellReuseIdentifier: AppConstants.TableViewCellIdentifiers.searchingTableViewCellID)
        myTableView.rowHeight = UITableView.automaticDimension
        myTableView.estimatedRowHeight = AppConstants.Sizes.estimatedTableViewHeight
        return myTableView
    }()

    // MARK: - Properties

    private var tableViewDataSource = SearchingScreenTableViewDataSource()
    private var tableViewDelegate: SearchingScreenTableViewDelegate?
    var cellTapped: ((IndexPath) -> Void)?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupElements()
        self.backgroundColor = .systemBackground
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ISearchingView

extension SearchingView: ISearchingView {
    func setupTableView(withPlace places: [Place]) {
        self.tableViewDataSource.places = places
        self.tableView.reloadData()
    }
}

// MARK: - UISetup

private extension SearchingView {
    func setupElements() {
        self.setupTableView()
    }

    func setupTableView() {
        self.tableViewDelegate = SearchingScreenTableViewDelegate(withDelegate: self)
        self.tableView.delegate = self.tableViewDelegate
        self.tableView.dataSource = self.tableViewDataSource
        self.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}

// MARK: - ICustomTableViewDelegate

extension SearchingView: ICustomTableViewDelegate {
    func selectedCell(indexPath: IndexPath) {
        cellTapped?(indexPath)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
