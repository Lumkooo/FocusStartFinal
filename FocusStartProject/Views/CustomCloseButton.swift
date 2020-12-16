//
//  CustomCloseButton.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/9/20.
//

import UIKit

final class CustomCloseButton: UIButton {
    
    // MARK: - Constants
    
    private enum Constants {
        static let closeViewButtonCornerRadius: CGFloat = 7
        static let xmarkImage = UIImage(systemName: "xmark")
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        self.setImage(Constants.xmarkImage, for: .normal)
        self.tintColor = .white
        self.backgroundColor = .black
        self.layer.cornerRadius = Constants.closeViewButtonCornerRadius
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

