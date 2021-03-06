//
//  MainScreenCollectionViewCell.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import UIKit

class MainScreenCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Constants
    
    private enum Constants {
        static let distanceToViewSize = CGSize(width: 150, height: 24)
        static let viewsAlphaComponent: CGFloat = 0.75
    }
    
    // MARK: - Properties
    
    static var reuseIdentifier: String {
        return String(describing: MainScreenCollectionViewCell.self)
    }
    private var placeName: String?
    private var stringImageURL: String?{
        didSet{
            imageView.image = nil
            updateUI()
        }
    }
    
    // MARK: - Views
    
    private var imageView: UIImageView = {
        let myImageView = UIImageView()
        myImageView.layer.cornerRadius = AppConstants.Sizes.cornerRadius
        return myImageView
    }()
    
    private var titleView: UIView = {
        let myView = UIView()
        myView.backgroundColor = UIColor.white.withAlphaComponent(Constants.viewsAlphaComponent)
        return myView
    }()
    
    private var titleLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.textAlignment = .natural
        myLabel.font = AppFonts.mainScreenCollectionViewCellLabelFont
        myLabel.textColor = .black
        myLabel.numberOfLines = 2
        return myLabel
    }()
    
    private lazy var distanceToLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.textColor = .white
        myLabel.backgroundColor = UIColor.black.withAlphaComponent(Constants.viewsAlphaComponent)
        myLabel.textAlignment = .right
        return myLabel
    }()
    
    private var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.color = .black
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupElements()
        self.setupLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - updateUI
    
    private func updateUI(){
        self.activityIndicatorView.startAnimating()
        if let stringURL = self.stringImageURL {
            ImageCache.loadImage(urlString: stringURL,
                                 nameOfPicture: "\(stringURL)-logo") { (urlString, image) in
                if urlString == self.stringImageURL {
                    self.imageView.image = image
                    self.activityIndicatorView.stopAnimating()
                }
            }
        } else {
            self.imageView.image = AppConstants.Images.errorImage
        }
    }
    
    override func prepareForReuse() {
        self.imageView.image = UIImage()
        self.stringImageURL = nil
        self.updateUI()
    }
    
    // MARK: - setupCell
    
    func setupCell(forPlace place: Place) {
        self.placeName = place.title
        self.titleLabel.text = place.title
        self.stringImageURL = place.imagefile
        if place.distance != nil {
            if let distance = place.distance,
               distance > 0 {
                self.setupDistanceToLabel()
                if distance < 1000{
                    self.distanceToLabel.text = "В \(Int(distance)) м от вас"
                }else{
                    let dist = String(format: "%.2f", distance/1000)
                    self.distanceToLabel.text = "В \(dist) км от вас"
                }
            }
        }
    }
}

// MARK: - UI setup

private extension MainScreenCollectionViewCell {
    func setupElements() {
        self.setupImageView()
        self.setupTitleView()
        self.setupLabel()
        self.setupActivityIndicatorView()
    }
    
    func setupImageView() {
        self.contentView.addSubview(self.imageView)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
        ])
    }
    
    func setupTitleView() {
        self.contentView.addSubview(self.titleView)
        self.titleView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.titleView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.titleView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.titleView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.titleView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor,
                                                   multiplier: 0.25)
        ])
    }
    
    func setupLabel() {
        self.titleView.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.titleView.leadingAnchor,
                                                     constant: AppConstants.Constraints.normalAnchorConstant),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.titleView.trailingAnchor,
                                                      constant: -AppConstants.Constraints.normalAnchorConstant),
            self.titleLabel.topAnchor.constraint(equalTo: self.titleView.topAnchor,
                                                 constant: AppConstants.Constraints.normalAnchorConstant),
        ])
    }
    
    func setupDistanceToLabel() {
        self.contentView.addSubview(self.distanceToLabel)
        self.distanceToLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.distanceToLabel.trailingAnchor.constraint(equalTo: self.imageView.trailingAnchor,
                                                           constant: -AppConstants.Constraints.halfNormalAnchorConstaint),
            self.distanceToLabel.topAnchor.constraint(equalTo: self.imageView.topAnchor)
        ])
    }
    
    func setupActivityIndicatorView() {
        self.imageView.addSubview(self.activityIndicatorView)
        self.activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.activityIndicatorView.centerYAnchor.constraint(equalTo: self.imageView.centerYAnchor),
            self.activityIndicatorView.centerXAnchor.constraint(equalTo: self.imageView.centerXAnchor)
        ])
    }
    
    func setupLayer() {
        self.layer.cornerRadius = AppConstants.Sizes.cornerRadius
        self.layer.borderWidth = AppConstants.Sizes.borderWidth
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true
        self.backgroundColor = .systemBackground
        self.contentView.layer.cornerRadius = AppConstants.Sizes.cornerRadius
        self.contentView.layer.borderWidth = AppConstants.Sizes.borderWidth
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = AppConstants.Sizes.shadowRadius
        self.layer.shadowOpacity = AppConstants.Sizes.shadowOpacity
        self.layer.cornerRadius = AppConstants.Sizes.cornerRadius
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds,
                                             cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
}
