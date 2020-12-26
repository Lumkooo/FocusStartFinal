//
//  RateView.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/26/20.
//

import UIKit

protocol IRateView: class {

}

final class RateView: UIView {

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupElements()
        self.backgroundColor = .red
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: IRateView

extension RateView: IRateView {

}


// MARK: - UISetup

private extension RateView {
    func setupElements() {

    }
}
