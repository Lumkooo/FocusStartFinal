//
//  CustomDoneView.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/16/20.
//

import UIKit

final class CustomDoneView: UIView {

    // MARK: - Views

    private lazy var label: UILabel = {
        let myLabel = UILabel()
        myLabel.numberOfLines = 0
        myLabel.font = AppFonts.titleLabelFont
        myLabel.textAlignment = .center
        myLabel.textColor = .white
        return myLabel
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        self.layer.cornerRadius = AppConstants.Sizes.cornerRadius
        self.setupElements()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    func setLabelText(text: String) {
        self.label.text = text
    }
}

// MARK: - UISetup

private extension CustomDoneView {
    func setupElements() {
        self.setupLabel()
    }

    func setupLabel() {
        self.addSubview(self.label)
        self.label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                constant: AppConstants.Constraints.halfNormalAnchorConstaint),
            self.label.topAnchor.constraint(equalTo: self.topAnchor,
                                                constant: AppConstants.Constraints.halfNormalAnchorConstaint),
            self.label.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                constant: -AppConstants.Constraints.halfNormalAnchorConstaint),
            self.label.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                constant: -AppConstants.Constraints.halfNormalAnchorConstaint),
        ])
    }
}

