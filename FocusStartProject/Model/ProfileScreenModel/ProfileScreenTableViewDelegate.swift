//
//  ProfileScreenTableViewDelegate.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/11/20.
//

import UIKit

protocol IProfileScreenTableViewDelegate: class {
    func selectedCell(indexPath: IndexPath)
}

final class ProfileScreenTableViewDelegate: NSObject {

    // MARK: - Constants

    private enum Constants {
        static let tableViewEstimatedHeight:CGFloat = 44
    }
    weak var delegate: IProfileScreenTableViewDelegate?

    // MARK: - Init

    init(withDelegate delegate: IProfileScreenTableViewDelegate) {
        self.delegate = delegate
    }
}

// MARK: - UITableViewDelegate

extension ProfileScreenTableViewDelegate: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectedCell(indexPath: indexPath)
    }

//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        Constants.tableViewEstimatedHeight
//    }
}
