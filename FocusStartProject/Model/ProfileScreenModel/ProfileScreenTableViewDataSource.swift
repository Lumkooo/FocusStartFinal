//
//  ProfileScreenTableViewDataSource.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/11/20.
//

import UIKit

final class ProfileScreenTableViewDataSource: NSObject {

    // MARK: Properties
    var previousOrders: [HistoryOrderEntity] = []
}

// MARK: UITableViewDataSource
extension ProfileScreenTableViewDataSource: UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        previousOrders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileViewTableViewCell.reuseIdentifier,
                                                 for: indexPath) as? ProfileViewTableViewCell
        else {
            assertionFailure("ooops, error occured!")
            return UITableViewCell()
        }

        let order = previousOrders[indexPath.row]
        cell.setupCell(food: order.food, time: order.time)
        return cell
    }
}
