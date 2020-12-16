//
//  SearchingScreenSearchBarDelegate.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/15/20.
//

import UIKit

protocol ISearchingScreenSearchBarDelegate: class {
    func textSearching(text: String, category: String)
}

final class SearchingScreenSearchBarDelegate: NSObject {

    // MARK: - Properties

    private weak var delegate: ISearchingScreenSearchBarDelegate?

    // MARK: - Init

    init(withDelegate delegate: ISearchingScreenSearchBarDelegate) {
        self.delegate = delegate
    }
}

// MARK: - UISearchBarDelegate

extension SearchingScreenSearchBarDelegate: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {
        guard let filterString = searchBar.text else {
            assertionFailure("Something went wrong")
            return
        }
        guard let scopeButtonTitles = searchBar.scopeButtonTitles else {
            return
        }
        let category = scopeButtonTitles[searchBar.selectedScopeButtonIndex]
        delegate?.textSearching(text: filterString, category: category)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        delegate?.textSearching(text: "", category: "Все")
    }

    func searchBar(_ searchBar: UISearchBar,
                   selectedScopeButtonIndexDidChange selectedScope: Int) {
        guard let scopeButtonTitles = searchBar.scopeButtonTitles else {
            return
        }
        let category = scopeButtonTitles[selectedScope]
        delegate?.textSearching(text: "", category: category)
    }
}
