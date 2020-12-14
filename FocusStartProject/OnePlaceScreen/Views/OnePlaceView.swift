//
//  OnePlaceView.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import UIKit
import MapKit

protocol IOnePlaceView: class {
    var menuButtonTapped: (() -> Void)? { get set }
    var adressButtonTapped: (() -> Void)? { get set }
    var likeButtonTapped: (() -> Void)? { get set }

    func setupView(place: Place, placeImage: UIImage)
    func setupLikeButton(isLiked: Bool)
}

final class OnePlaceView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let anchorConstant:CGFloat = 16
        static let titleAnchorConstant:CGFloat = 32
        static let constraintsMultiplier:CGFloat = 0.65
        static let topImageWidth:CGFloat = UIScreen.main.bounds.width
        static let placeLocationMapSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        static let buttonHeight: CGFloat = 50
        static let buttonCornerRadius: CGFloat = 15
        static let buttonShadowRadius: CGFloat = 5
        static let buttonShadowOpacity: Float = 1
    }

    // MARK: - Views

    private let activityIndicator: UIActivityIndicatorView = {
        let myActivityIndicatorView = UIActivityIndicatorView()
        myActivityIndicatorView.hidesWhenStopped = true
        myActivityIndicatorView.startAnimating()
        return myActivityIndicatorView
    }()

    private let scrollView: UIScrollView={
        let myScrollView = UIScrollView()
        return myScrollView
    }()

    private let topImageView: UIImageView={
        let myImageView = UIImageView()
        myImageView.contentMode = .redraw
        return myImageView
    }()

    private let likeButton: UIButton = {
        let myButton = UIButton()
        myButton.tintColor = .red
        myButton.addTarget(self, action: #selector(likeButtonTapepd(gesture:)), for: .touchUpInside)
        return myButton
    }()

    private let titleLabel: UILabel={
        let myLabel = UILabel()
        myLabel.numberOfLines = 0
        myLabel.font = AppFonts.largeTitleLabelFont
        return myLabel
    }()

    private let descriptionLabel: UILabel={
        let myLabel = UILabel()
        myLabel.numberOfLines = 0
        myLabel.font = AppFonts.titleLabelFont
        return myLabel
    }()

    private let menuButton: CustomButton={
        let myButton = CustomButton()
        myButton.setTitle("Перейти к меню", for: .normal)
        myButton.addTarget(self, action: #selector(menuButtonTapped(gesute:)), for: .touchUpInside)
        return myButton
    }()

    private let placeLocationMapView: MKMapView={
        let mapView = MKMapView()
        mapView.mapType = MKMapType.standard
        mapView.isScrollEnabled = false
        mapView.isPitchEnabled = false
        mapView.isRotateEnabled = false
        mapView.isZoomEnabled = false
        mapView.register(PlacesArtowrkView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        return mapView
    }()

    private let routeToPlaceButton: UIButton={
        let myButton = UIButton()
        myButton.backgroundColor = .black
        myButton.setTitleColor(.white, for: .normal)
        myButton.setTitle("Построить маршрут", for: .normal)
        myButton.layer.cornerRadius = Constants.buttonCornerRadius
        myButton.layer.shadowOpacity = Constants.buttonShadowOpacity
        myButton.layer.shadowRadius = Constants.buttonShadowRadius
        myButton.layer.shadowColor = UIColor.black.cgColor
        myButton.alpha = 0.65
        myButton.addTarget(self, action: #selector(routeToPlaceButtonTapped(gesute:)), for: .touchUpInside)
        return myButton
    }()

    // MARK: - Properties

    var menuButtonTapped: (() -> Void)?
    var adressButtonTapped: (() -> Void)?
    var likeButtonTapped: (() -> Void)?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        self.setupActivityIndicator()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func routeToPlaceButtonTapped(gesute: UIGestureRecognizer) {
        self.adressButtonTapped?()
    }

    @objc private func menuButtonTapped(gesute: UIGestureRecognizer) {
        self.menuButtonTapped?()
    }

    @objc private func likeButtonTapepd(gesture: UIGestureRecognizer) {
        self.likeButtonTapped?()
    }
}

// MARK: - UISetup

private extension OnePlaceView {
    func setupElements() {
        self.setupScrollView()
        self.setupTopImageView()
        self.setupLikeButton()
        self.setupTitleLabel()
        self.setupDesriptionLabel()
        self.setupMenuButton()
        self.setupLocationMapView()
        self.setupRouteToPlaceButton()
    }

    func setupScrollView() {
        self.addSubview(self.scrollView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    func setupTopImageView() {
        self.scrollView.addSubview(self.topImageView)
        self.topImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.topImageView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.topImageView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.topImageView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.topImageView.widthAnchor.constraint(equalToConstant: Constants.topImageWidth),
            self.topImageView.heightAnchor.constraint(equalTo: self.topImageView.widthAnchor,
                                                      multiplier: Constants.constraintsMultiplier)
        ])
    }

    func setupLikeButton() {
        self.scrollView.addSubview(self.likeButton)
        self.likeButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.likeButton.topAnchor.constraint(equalTo: self.topImageView.bottomAnchor,
                                                 constant: Constants.anchorConstant),
            self.likeButton.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor,
                                                 constant: -Constants.anchorConstant),
            self.likeButton.heightAnchor.constraint(equalToConstant: AppConstants.Sizes.likeButtonSize.height),
            self.likeButton.widthAnchor.constraint(equalToConstant: AppConstants.Sizes.likeButtonSize.width)
        ])
    }

    func setupTitleLabel() {
        self.scrollView.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.topImageView.bottomAnchor,
                                                 constant: Constants.anchorConstant),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor,
                                                 constant: Constants.titleAnchorConstant),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.likeButton.leadingAnchor,
                                                 constant: -Constants.anchorConstant),
        ])
    }

    func setupDesriptionLabel() {
        self.scrollView.addSubview(self.descriptionLabel)
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.descriptionLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor,
                                                       constant: Constants.anchorConstant),
            self.descriptionLabel.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor,
                                                           constant: Constants.anchorConstant),
            self.descriptionLabel.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor,
                                                            constant: -Constants.anchorConstant),
        ])
    }

    func setupMenuButton() {
        self.scrollView.addSubview(self.menuButton)
        self.menuButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.menuButton.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor,
                                                       constant: Constants.anchorConstant),
            self.menuButton.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor,
                                                     constant: Constants.anchorConstant),
            self.menuButton.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor,
                                                      constant: -Constants.anchorConstant),
            self.menuButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
    }

    func setupLocationMapView() {
        self.scrollView.addSubview(self.placeLocationMapView)
        self.placeLocationMapView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.placeLocationMapView.topAnchor.constraint(equalTo: self.menuButton.bottomAnchor,
                                                       constant: Constants.anchorConstant),
            self.placeLocationMapView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.placeLocationMapView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.placeLocationMapView.heightAnchor.constraint(equalTo: self.topImageView.widthAnchor,
                                                      multiplier: Constants.constraintsMultiplier),
            self.placeLocationMapView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor,
                                                          constant: -Constants.anchorConstant)
        ])
    }

    func setupRouteToPlaceButton() {
        self.scrollView.addSubview(self.routeToPlaceButton)
        self.routeToPlaceButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.routeToPlaceButton.bottomAnchor.constraint(equalTo: self.placeLocationMapView.bottomAnchor,
                                                       constant: -Constants.anchorConstant),
            self.routeToPlaceButton.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor,
                                                             constant: Constants.anchorConstant),
            self.routeToPlaceButton.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor,
                                                              constant: -Constants.anchorConstant),
            self.routeToPlaceButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
    }
}

// MARK: - Настройка activityIndicator-а, отображаемого при загрузке экрана

private extension OnePlaceView {
    func setupActivityIndicator() {
        self.addSubview(self.activityIndicator)
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}

extension OnePlaceView: IOnePlaceView {
    func setupView(place: Place, placeImage: UIImage) {
        self.activityIndicator.stopAnimating()
        self.setupElements()
        guard let title = place.title,
              let description = place.descriptionText else {
            return
        }
        self.titleLabel.text = title
        self.topImageView.image = placeImage
        self.descriptionLabel.text = "Информация о заведении:\n\(description)"
        self.setupMap(forPlace: place)
    }

    func setupLikeButton(isLiked: Bool) {
        if isLiked {
            self.likeButton.setImage(AppConstants.Images.likeFilled, for: .normal)
        } else {
            self.likeButton.setImage(AppConstants.Images.like, for: .normal)
        }
    }
}


private extension OnePlaceView {
    func setupMap(forPlace place: Place) {
        let region = MKCoordinateRegion(center: place.coordinate,
                                        span: Constants.placeLocationMapSpan)
        self.placeLocationMapView.setRegion(region,
                                            animated: false)
        self.placeLocationMapView.addAnnotation(place)
    }
}
