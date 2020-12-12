//
//  ProfileViewTableViewCell.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/11/20.
//

import UIKit

final class ProfileViewTableViewCell: UITableViewCell {

    // MARK: - Constants

    private enum Constants {
        static let anchorXConstant: CGFloat = 16
        static let anchorYConstant: CGFloat = 8
        static let timeLabelMultiplier: CGFloat = 0.5
    }

    // MARK: - Properties

    static var reuseIdentifier: String {
        return String(describing: ProfileViewTableViewCell.self)
    }

    // MARK: - Views

    private lazy var foodNameLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.textAlignment = .left
        myLabel.numberOfLines = 0
        return myLabel
    }()

    private lazy var timeLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.textAlignment = .right
        return myLabel
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupElements()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Method
    func setupCell(food: String, time: String) {
        self.timeLabel.text = time
        self.foodNameLabel.text = food
    }
}

private extension ProfileViewTableViewCell {
    func setupElements() {
        self.setupTimeLabel()
        self.setupFoodNameLabel()
    }

    func setupTimeLabel() {
        self.contentView.addSubview(self.timeLabel)
        self.timeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.timeLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,
                                                     constant: -Constants.anchorXConstant),
            self.timeLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,
                                                     constant: -Constants.anchorYConstant),
            self.timeLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor,
                                                     constant: Constants.anchorYConstant),
            self.timeLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor,
                                                  multiplier: Constants.timeLabelMultiplier),
        ])
    }

    func setupFoodNameLabel() {
        self.contentView.addSubview(self.foodNameLabel)
        self.foodNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.foodNameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,
                                                        constant: Constants.anchorXConstant),
            self.foodNameLabel.trailingAnchor.constraint(equalTo: self.timeLabel.leadingAnchor,
                                                        constant: -Constants.anchorXConstant),
            self.foodNameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor,
                                                        constant: Constants.anchorYConstant),
            self.foodNameLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,
                                                        constant: -Constants.anchorYConstant)
        ])
    }
}
