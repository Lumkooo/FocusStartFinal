//
//  CustomButton.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/8/20.
//

import UIKit

final class CustomButton: UIButton {
    // MARK: - Constants

    private enum Constants {
        static let buttonCornerRadius: CGFloat = 15
        static let buttonShadowRadius: CGFloat = 5
        static let buttonShadowOpacity: Float = 1
    }

    // MARK: - Fonts

    private enum Fonts {
        static let buttonFont = UIFont.systemFont(ofSize: 20, weight: .regular)
    }

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        self.setTitleColor(.white, for: .normal)
        self.layer.cornerRadius = Constants.buttonCornerRadius
        self.layer.shadowOpacity = Constants.buttonShadowOpacity
        self.layer.shadowRadius = Constants.buttonShadowRadius
        self.titleLabel?.font = Fonts.buttonFont
        self.layer.shadowColor = UIColor.black.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

