//
//  SearchingScreenTableViewDataSource.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/14/20.
//

import UIKit

final class SearchingScreenTableViewDataSource: NSObject {

    // MARK: Properties

    var places: [Place] = []
}

// MARK: UITableViewDataSource

extension SearchingScreenTableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        self.places.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: AppConstants.TableViewCellIdentifiers.searchingTableViewCellID,
            for: indexPath)
        // Добавил проверку есть ли что либо по этому индексу
        if self.places.count >= indexPath.row {
            let place = self.places[indexPath.row]
            if let title = place.title  {
                cell.textLabel?.text = title
            }
        }
        return cell
    }
}
