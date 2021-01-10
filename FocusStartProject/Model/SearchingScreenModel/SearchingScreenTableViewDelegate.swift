//
//  SearchingScreenTableViewDelegate.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/14/20.
//

import UIKit

final class SearchingScreenTableViewDelegate: NSObject {

    // MARK: - Properties

    private weak var delegate: ICustomTableViewDelegate?

    // MARK: - Init

    init(withDelegate delegate: ICustomTableViewDelegate) {
        self.delegate = delegate
    }
}

// MARK: - UITableViewDelegate

extension SearchingScreenTableViewDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        delegate?.selectedCell(indexPath: indexPath)
    }
}
