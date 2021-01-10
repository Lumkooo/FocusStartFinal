//
//  CustomButton.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/8/20.
//

import UIKit

final class CustomButton: UIButton {

    // MARK: - Fonts

    private enum Fonts {
        static let buttonFont = UIFont.systemFont(ofSize: 20, weight: .regular)
    }

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        self.setTitleColor(.white, for: .normal)
        self.layer.cornerRadius = AppConstants.Sizes.cornerRadius
        self.layer.shadowOpacity = AppConstants.Sizes.shadowOpacity
        self.layer.shadowRadius = AppConstants.Sizes.shadowRadius
        self.titleLabel?.font = Fonts.buttonFont
        self.layer.shadowColor = UIColor.black.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

