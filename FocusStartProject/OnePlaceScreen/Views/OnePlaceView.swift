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
    var rateButtonTapped: (() -> Void)? { get set }
    
    func setupView(place: Place, placeImage: UIImage)
    func setupLikeButton(isLiked: Bool)
    func showDoneView(_ isLiked: Bool)
    func setupRatingViews(ratingEntity: RatingEntity)
}

// MARK: - Да, кнопка оценить заведение находится в странном месте, но я просто не знаю куда ее еще девать...
// Снизу будет не очень, так что пусть останется здесь

final class OnePlaceView: UIView {
    
    // MARK: - Constants

    private enum Constants {
        // Устанавливаем высоту картинки и карты в зависимости от их ширины
        static let constraintsMultiplier: CGFloat = 0.65
        static let placeLocationMapSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        static let viewsAlphaComponent: CGFloat = 0.75
    }
    
    // MARK: - Views
    
    private let activityIndicator: UIActivityIndicatorView = {
        let myActivityIndicatorView = UIActivityIndicatorView()
        myActivityIndicatorView.hidesWhenStopped = true
        myActivityIndicatorView.startAnimating()
        return myActivityIndicatorView
    }()
    
    private let scrollView: UIScrollView = {
        let myScrollView = UIScrollView()
        return myScrollView
    }()
    
    private let topImageView: UIImageView = {
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
    
    private let titleLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.numberOfLines = 0
        myLabel.font = AppFonts.largeTitleLabelFont
        return myLabel
    }()
    
    private let descriptionLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.numberOfLines = 0
        myLabel.font = AppFonts.titleLabelFont
        return myLabel
    }()
    
    private let menuButton: CustomButton = {
        let myButton = CustomButton()
        myButton.setTitle("Перейти к меню", for: .normal)
        myButton.addTarget(self, action: #selector(menuButtonTapped(gesute:)), for: .touchUpInside)
        myButton.accessibilityIdentifier = "menuButton"
        return myButton
    }()
    
    private let placeLocationMapView: MKMapView = {
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
    
    private let routeToPlaceButton: UIButton = {
        let myButton = UIButton()
        myButton.backgroundColor = .black
        myButton.setTitleColor(.white, for: .normal)
        myButton.setTitle("Построить маршрут", for: .normal)
        myButton.layer.cornerRadius = AppConstants.Sizes.cornerRadius
        myButton.layer.shadowOpacity = AppConstants.Sizes.shadowOpacity
        myButton.layer.shadowRadius = AppConstants.Sizes.shadowRadius
        myButton.layer.shadowColor = UIColor.black.cgColor
        myButton.alpha = 0.65
        myButton.addTarget(self,
                           action: #selector(routeToPlaceButtonTapped(gesute:)),
                           for: .touchUpInside)
        return myButton
    }()

    private lazy var doneView: CustomDoneView = {
        let myDoneView = CustomDoneView()
        return myDoneView
    }()

    private let ratingLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.font = AppFonts.titleLabelFont
        myLabel.textColor = .white
        myLabel.backgroundColor = UIColor.black.withAlphaComponent(Constants.viewsAlphaComponent)
        myLabel.textAlignment = .right
        myLabel.numberOfLines = 0
        return myLabel
    }()

    private lazy var rateButton: CustomButton = {
        let myCustomButton = CustomButton()
        myCustomButton.setTitle("Оценить заведение", for: .normal)
        myCustomButton.addTarget(self,
                           action: #selector(rateButtonTapped(gesture:)),
                           for: .touchUpInside)
        return myCustomButton
    }()
    
    // MARK: - Properties
    
    var menuButtonTapped: (() -> Void)?
    var adressButtonTapped: (() -> Void)?
    var likeButtonTapped: (() -> Void)?
    var rateButtonTapped: (() -> Void)?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        self.setupActivityIndicator()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Обработка нажатий на кнопки
    
    @objc private func routeToPlaceButtonTapped(gesute: UIGestureRecognizer) {
        self.adressButtonTapped?()
    }
    
    @objc private func menuButtonTapped(gesute: UIGestureRecognizer) {
        self.menuButtonTapped?()
    }
    
    @objc private func likeButtonTapepd(gesture: UIGestureRecognizer) {
        self.likeButtonTapped?()
    }

    @objc private func rateButtonTapped(gesture: UIGestureRecognizer) {
        self.rateButtonTapped?()
    }
}

// MARK: - UISetup

private extension OnePlaceView {
    func setupElements() {
        self.setupScrollView()
        self.setupTopImageView()
        self.setupLikeButton()
        self.setupTitleLabel()
        self.setupLocationMapView()
        self.setupRouteToPlaceButton()
        self.setupDescriptionLabel()
        self.setupMenuButton()
        self.setupRatingLabel()
        self.setupRatingButton()
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
            self.topImageView.widthAnchor.constraint(equalToConstant: AppConstants.screenWidth),
            self.topImageView.heightAnchor.constraint(equalTo: self.topImageView.widthAnchor,
                                                      multiplier: Constants.constraintsMultiplier)
        ])
    }
    
    func setupLikeButton() {
        self.scrollView.addSubview(self.likeButton)
        self.likeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.likeButton.topAnchor.constraint(equalTo: self.topImageView.bottomAnchor,
                                                 constant: AppConstants.Constraints.normalAnchorConstant),
            self.likeButton.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor,
                                                      constant: -AppConstants.Constraints.normalAnchorConstant),
            self.likeButton.heightAnchor.constraint(equalToConstant: AppConstants.Sizes.likeButtonSize.height),
            self.likeButton.widthAnchor.constraint(equalToConstant: AppConstants.Sizes.likeButtonSize.width)
        ])
    }
    
    func setupTitleLabel() {
        self.scrollView.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.topImageView.bottomAnchor,
                                                 constant: AppConstants.Constraints.normalAnchorConstant),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor,
                                                     constant: AppConstants.Constraints.twiceNormalAnchorConstant),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.likeButton.leadingAnchor,
                                                      constant: -AppConstants.Constraints.normalAnchorConstant),
        ])
    }

    func setupLocationMapView() {
        self.scrollView.addSubview(self.placeLocationMapView)
        self.placeLocationMapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.placeLocationMapView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor,
                                                           constant: AppConstants.Constraints.normalAnchorConstant),
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
            self.routeToPlaceButton.bottomAnchor.constraint(
                equalTo: self.placeLocationMapView.bottomAnchor,
                constant: -AppConstants.Constraints.normalAnchorConstant),
            self.routeToPlaceButton.leadingAnchor.constraint(
                equalTo: self.scrollView.leadingAnchor,
                constant: AppConstants.Constraints.normalAnchorConstant),
            self.routeToPlaceButton.trailingAnchor.constraint(
                equalTo: self.scrollView.trailingAnchor,
                constant: -AppConstants.Constraints.normalAnchorConstant),
            self.routeToPlaceButton.heightAnchor.constraint(equalToConstant: AppConstants.Sizes.buttonsHeight)
        ])
    }

    func setupDescriptionLabel() {
        self.scrollView.addSubview(self.descriptionLabel)
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.descriptionLabel.topAnchor.constraint(
                equalTo: self.placeLocationMapView.bottomAnchor,
                constant: AppConstants.Constraints.normalAnchorConstant),
            self.descriptionLabel.leadingAnchor.constraint(
                equalTo: self.scrollView.leadingAnchor,
                constant: AppConstants.Constraints.normalAnchorConstant),
            self.descriptionLabel.trailingAnchor.constraint(
                equalTo: self.scrollView.trailingAnchor,
                constant: -AppConstants.Constraints.normalAnchorConstant),
        ])
    }

    func setupMenuButton() {
        self.scrollView.addSubview(self.menuButton)
        self.menuButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.menuButton.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor,
                                                 constant: AppConstants.Constraints.normalAnchorConstant),
            self.menuButton.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor,
                                                     constant: AppConstants.Constraints.normalAnchorConstant),
            self.menuButton.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor,
                                                      constant: -AppConstants.Constraints.normalAnchorConstant),
            self.menuButton.heightAnchor.constraint(equalToConstant: AppConstants.Sizes.buttonsHeight),
            self.menuButton.bottomAnchor.constraint(
                equalTo: self.scrollView.bottomAnchor,
                constant: -AppConstants.Constraints.normalAnchorConstant),
        ])
    }

    func setupRatingLabel() {
        self.scrollView.addSubview(self.ratingLabel)
        self.ratingLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.ratingLabel.topAnchor.constraint(
                equalTo: self.scrollView.topAnchor,
                constant: AppConstants.Constraints.quarterNormalAnchorConstaint),
            self.ratingLabel.trailingAnchor.constraint(
                equalTo: self.scrollView.trailingAnchor,
                constant: -AppConstants.Constraints.quarterNormalAnchorConstaint)
        ])
    }

    func setupRatingButton() {
        self.scrollView.addSubview(self.rateButton)
        self.rateButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.rateButton.topAnchor.constraint(
                equalTo: self.ratingLabel.bottomAnchor,
                constant: AppConstants.Constraints.quarterNormalAnchorConstaint),
            self.rateButton.trailingAnchor.constraint(
                equalTo: self.topImageView.trailingAnchor,
                constant: -AppConstants.Constraints.quarterNormalAnchorConstaint),
            self.rateButton.heightAnchor.constraint(equalToConstant: 50)
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

// MARK: - IOnePlaceView

extension OnePlaceView: IOnePlaceView {
    func setupView(place: Place,
                   placeImage: UIImage) {
        self.activityIndicator.stopAnimating()
        self.setupElements()
        guard let title = place.title,
              let description = place.descriptionText else {
            return
        }
        self.titleLabel.text = title
        self.topImageView.image = placeImage
        setupDescriptionLabelText(place, description)
        self.setupMap(forPlace: place)
    }
    
    func setupLikeButton(isLiked: Bool) {
        if isLiked {
            // Показываем doneView с текстом о том, что запись добавлена в избранные
            self.likeButton.setImage(AppConstants.Images.likeFilled, for: .normal)
        } else {
            // Показываем doneView с текстом о том, что запись удалена из избранных
            self.likeButton.setImage(AppConstants.Images.like, for: .normal)
        }
    }
    
    private func setupDescriptionLabelText(_ place: Place,
                                           _ description: String) {
        if let distance = place.distance,
           distance > 0 {
            // Округлим до 1 знака после запятой
            let roundedDistance = Double(round(10*distance)/10)
            self.descriptionLabel.text = "Информация о заведении:\n\(description)\n\nЗаведение находится в \(roundedDistance) м. от вас"
        } else {
            self.descriptionLabel.text = "Информация о заведении:\n\(description)"
        }
    }

    func showDoneView(_ isLiked: Bool) {
        if isLiked {
            self.setupAddedDoneView()
        } else {
            self.setupRemovedDoneView()
        }
    }

    func setupRatingViews(ratingEntity: RatingEntity) {
        if ratingEntity.ratingCount > 0 {
            self.ratingLabel.isHidden = false
            self.ratingLabel.text = "Рейтинг заведения: \(ratingEntity.currentRating).\nРейтинг на основе \(ratingEntity.ratingCount) оценок."
        } else {
            self.ratingLabel.isHidden = true
        }
    }
}

// MARK: - Настройка аннотации и региона на карте

private extension OnePlaceView {
    func setupMap(forPlace place: Place) {
        let region = MKCoordinateRegion(center: place.coordinate,
                                        span: Constants.placeLocationMapSpan)
        self.placeLocationMapView.setRegion(region,
                                            animated: false)
        self.placeLocationMapView.addAnnotation(place)
    }
}

// MARK: - Настройка показывания doneView

private extension OnePlaceView {
    func setupAddedDoneView() {
        self.addDoneViewOnScreen(withText: "Заведение добавлено в список избранных")
    }

    func setupRemovedDoneView() {
        self.addDoneViewOnScreen(withText: "Заведение удалено из списка избранных")
    }

    func addDoneViewOnScreen(withText text: String) {

        self.likeButton.isUserInteractionEnabled = false
        self.doneView.setLabelText(text: text)
        self.addSubview(self.doneView)
        self.doneView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.doneView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.doneView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.doneView.widthAnchor.constraint(equalToConstant: AppConstants.Sizes.doneViewSize.width),
            self.doneView.heightAnchor.constraint(equalToConstant: AppConstants.Sizes.doneViewSize.height)
        ])
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.doneView.removeFromSuperview()
            self.likeButton.isUserInteractionEnabled = true
        }
    }
}
