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

    // MARK: - Constants

    private enum Constants {
        static let animationDuration = 1.5
        static let delayConstant = 0.05
        static let usingSpringWithDamping: CGFloat = 0.8
    }

    // MARK: - Views

    private let tableView: UITableView = {
        let myTableView = UITableView()
        myTableView.register(
            UITableViewCell.self,
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
        self.backgroundColor = .systemBackground
        self.setupElements()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ISearchingView

extension SearchingView: ISearchingView {
    func setupTableView(withPlace places: [Place]) {
        self.tableViewDataSource.places = places
        self.animateTable()
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

    func animateTable() {
        self.tableView.reloadData()

        let cells = self.tableView.visibleCells
        let tableHeight = self.tableView.bounds.size.height

        // move all cells to the bottom of the screen
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }

        // move all cells from bottom to the right place
        var index = 0
        for cell in cells {
            UIView.animate(withDuration: Constants.animationDuration,
                           delay: Constants.delayConstant * Double(index),
                           usingSpringWithDamping: Constants.usingSpringWithDamping,
                           initialSpringVelocity: 0,
                           options: [],
                           animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: nil)
            index += 1
        }
    }
}

// MARK: - ICustomTableViewDelegate

extension SearchingView: ICustomTableViewDelegate {
    func selectedCell(indexPath: IndexPath) {
        cellTapped?(indexPath)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
