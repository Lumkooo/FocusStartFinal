//
//  ProfileScreenTableViewDelegate.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/11/20.
//

import UIKit

final class ProfileScreenTableViewDelegate: NSObject {

    // MARK: - Properties

    private weak var delegate: ICustomTableViewDelegate?

    // MARK: - Init

    init(withDelegate delegate: ICustomTableViewDelegate) {
        self.delegate = delegate
    }
}

// MARK: - UITableViewDelegate

extension ProfileScreenTableViewDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        delegate?.selectedCell(indexPath: indexPath)
    }
}
