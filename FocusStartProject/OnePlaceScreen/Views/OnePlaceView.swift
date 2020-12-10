//
//  OnePlaceView.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import UIKit
import MapKit

protocol IOnePlaceView: class {
    var didTouchMenuButton: (() -> Void)? { get set }
    var didTouchAddress: (() -> Void)? { get set }

    func setupView(place: Place, placeImage: UIImage)
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

    // MARK: - Fonts

    private enum Fonts {
        static let titleLabelFont = UIFont.systemFont(ofSize: 26, weight: .semibold)
        static let subtitlesFonts = UIFont.systemFont(ofSize: 22, weight: .semibold)
        static let otherLabelsFont = UIFont.systemFont(ofSize: 20)
    }

    // MARK: - Views

    private let scrollView: UIScrollView={
        let myScrollView = UIScrollView()
        return myScrollView
    }()

    private let topImageView: UIImageView={
        let myImageView = UIImageView()
        myImageView.contentMode = .redraw
        return myImageView
    }()

    private let titleLabel: UILabel={
        let myLabel = UILabel()
        myLabel.numberOfLines = 0
        myLabel.font = Fonts.titleLabelFont
        return myLabel
    }()

    private let descriptionStaticLabel: UILabel={
        let myLabel = UILabel()
        myLabel.numberOfLines = 0
        myLabel.text = "Информация о заведении:"
        myLabel.font = Fonts.subtitlesFonts
        return myLabel
    }()

    private let descriptionLabel: UILabel={
        let myLabel = UILabel()
        myLabel.numberOfLines = 0
        myLabel.font = Fonts.otherLabelsFont
        return myLabel
    }()

    private let menuButton: CustomButton={
        let myButton = CustomButton()
        myButton.setTitle("Перейти к меню", for: .normal)
        myButton.addTarget(self, action: #selector(menuButtonTapped(gesute:)), for: .touchUpInside)
        return myButton
    }()


    private let placeLocationLabel: UILabel={
        let myLabel = UILabel()
        myLabel.numberOfLines = 0
        myLabel.text = "Расположение заведения:"
        myLabel.font = Fonts.subtitlesFonts
        return myLabel
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

    var didTouchMenuButton: (() -> Void)?
    var didTouchAddress: (() -> Void)?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        self.setupElements()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func routeToPlaceButtonTapped(gesute: UIGestureRecognizer) {
        didTouchAddress?()
    }

    @objc private func menuButtonTapped(gesute: UIGestureRecognizer) {
        didTouchMenuButton?()
    }
}

// MARK: - Установка constraint-ов для элементов

private extension OnePlaceView {
    func setupElements() {
        self.setupScrollView()
        self.setupTopImageView()
        self.setupTitleLabel()
        self.setupDesctiption()
        self.setupMenuButton()
        self.setupPlaceLocationElements()
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

    func setupTitleLabel() {
        self.scrollView.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.topImageView.bottomAnchor,
                                                 constant: Constants.anchorConstant),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor,
                                                 constant: Constants.titleAnchorConstant),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor,
                                                 constant: -Constants.anchorConstant),
        ])
    }

    func setupDesctiption() {
        self.setupDescriptionStaticLabel()
        self.setupDesriptionLabel()
    }

    func setupDescriptionStaticLabel() {
        self.scrollView.addSubview(self.descriptionStaticLabel)
        self.descriptionStaticLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.descriptionStaticLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor,
                                                             constant: Constants.anchorConstant),
            self.descriptionStaticLabel.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor,
                                                                 constant: Constants.anchorConstant),
            self.descriptionStaticLabel.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor,
                                                                  constant: -Constants.anchorConstant),
        ])
    }

    func setupDesriptionLabel() {
        self.scrollView.addSubview(self.descriptionLabel)
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.descriptionLabel.topAnchor.constraint(equalTo: self.descriptionStaticLabel.bottomAnchor,
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

    func setupPlaceLocationElements() {
        self.setupPlaceLocationLabel()
        self.setupLocationMapView()
    }

    func setupPlaceLocationLabel() {
        self.scrollView.addSubview(self.placeLocationLabel)
        self.placeLocationLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.placeLocationLabel.topAnchor.constraint(equalTo: self.menuButton.bottomAnchor,
                                                       constant: Constants.anchorConstant),
            self.placeLocationLabel.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor,
                                                           constant: Constants.anchorConstant),
            self.placeLocationLabel.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor,
                                                            constant: -Constants.anchorConstant),
        ])
    }

    func setupLocationMapView() {
        self.scrollView.addSubview(self.placeLocationMapView)
        self.placeLocationMapView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.placeLocationMapView.topAnchor.constraint(equalTo: self.placeLocationLabel.bottomAnchor,
                                                       constant: Constants.anchorConstant),
            self.placeLocationMapView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.placeLocationMapView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.placeLocationMapView.heightAnchor.constraint(equalTo: self.topImageView.widthAnchor,
                                                      multiplier: Constants.constraintsMultiplier)
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
            self.routeToPlaceButton.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor,
                                                          constant: -Constants.anchorConstant),
            self.routeToPlaceButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
    }
}

extension OnePlaceView: IOnePlaceView {
    func setupView(place: Place, placeImage: UIImage) {
        guard let title = place.title,
              let description = place.descriptionText else {
            return
        }
        self.titleLabel.text = title
        self.topImageView.image = placeImage
        self.descriptionLabel.text = description
        setupMap(forPlace: place)

    }
}


private extension OnePlaceView {
    func setupMap(forPlace place: Place) {
        self.placeLocationMapView.setRegion(MKCoordinateRegion(center: place.coordinate,
                                                               span: Constants.placeLocationMapSpan),
                                            animated: false)
        self.placeLocationMapView.addAnnotation(place)
    }
}
