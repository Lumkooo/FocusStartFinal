//
//  PurchasingPresenter.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/9/20.
//

import Foundation

protocol IPurchasingPresenter {
    func viewDidLoad(ui: IPurchasingView)
    func viewWillAppear()
}

final class PurchasingPresenter {
    
    // MARK: - Properties
    
    private weak var ui: IPurchasingView?
    private var interactor: IPurchasingInteractor
    private var router: IPurchasingRouter
    
    // MARK: - Init
    
    init(interactor: IPurchasingInteractor,
         router: IPurchasingRouter) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - IPurchasingPresenter

extension PurchasingPresenter: IPurchasingPresenter {
    func viewDidLoad(ui: IPurchasingView) {
        self.ui = ui
        self.ui?.selfPickupButtonTapped = {
            self.interactor.selfPickupChosen()
        }
        self.ui?.toUserButtonTapped = {
            self.interactor.toUserDeliveryChosen()
        }
        self.ui?.didSelectSegmentControl = { [weak self] segmentTitle in
            self?.interactor.getTimePresentation(forSegmentControlTitle: segmentTitle)
        }
        self.ui?.orderButtonTapped = { [weak self] timeText in
            self?.interactor.order(time: timeText)
        }
        self.interactor.loadInitData()
    }
    
    func viewWillAppear() {
        self.interactor.showPrice()
    }
}

// MARK: - IPurchasingInteractorOuter

extension PurchasingPresenter: IPurchasingInteractorOuter {
    func setupUserLocationOnUI() {
        self.ui?.setupUserLocationOnUI()
    }
    
    func setupSelfPickupOnUI() {
        self.ui?.setupSelfPickupOnUI()
    }
    
    func errorOccured(errorDecription: String) {
        self.router.showAlert(errorDecription: errorDecription)
    }
    
    func returnTimePresentation(timePresentation: [String]) {
        self.ui?.returnTimePresentation(timePresentation: timePresentation)
    }
    
    func soonTimeChosen() {
        self.ui?.hideTimeTextField()
    }
    
    func toTimeChosen() {
        self.ui?.showTimeTextField()
    }
    
    func setupTotalPrice(totalPrice: String) {
        self.ui?.setupTotalPriceLabel(totalPrice: totalPrice)
    }
    
    func finishPurchasing() {
        self.router.showFinishPuchasingVC()
    }
}
