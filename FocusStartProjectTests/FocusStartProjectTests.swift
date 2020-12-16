//
//  FocusStartProjectTests.swift
//  FocusStartProjectTests
//
//  Created by Андрей Шамин on 12/7/20.
//

import XCTest
import MapKit
@testable import FocusStartProject

class FocusStartProjectTests: XCTestCase {

    // MARK: - Сделал, но почему-то кажется, что сделал какую-то фигню =(
    // Раньше с тестами не сталкивался, поэтому не очень понимаю как это делается

    var timeManager: TimeManager!
    var firebaseAuthManager: FirebaseAuthManager!
    var place: Place!
    var mainInteractor: IMainInteractor!

    override func setUpWithError() throws {
        super.setUp()
        timeManager = TimeManager()
        firebaseAuthManager = FirebaseAuthManager()
        place = Place(title: "Place",
                          locationName: "LocationName",
                          discipline: "discipline",
                          coordinate: CLLocationCoordinate2D(latitude: 50, longitude: 50),
                          imagefile: "imageFile",
                          descriptionText: "descriptionText",
                          distance: 0,
                          isSale: false)
        mainInteractor = MainInteractor()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        timeManager = nil
        firebaseAuthManager = nil
        super.tearDown()
    }

    func testAuthLogout() {
        firebaseAuthManager.logout {
            XCTAssertNil(firebaseAuthManager.userUID)
        } errorCompletion: { (error) in
            fatalError(error.localizedDescription)
        }
    }

    func testFinalPurchasingVCAssembly() {
        let vc = FinalPurchasingVCAssembly.createVC()
        XCTAssertTrue((vc as? FinalPurchasingViewController) != nil, "error")
    }

    func testPlaceLoaderDisciplines() {
        let disciplines = PlaceLoader.sharedInstance.getDisciplines()
        XCTAssertFalse(disciplines.isEmpty, "В массиве ничего нет")
    }

    func testPlaceLoaderPlacesForDisciplines() {
        let food = PlaceLoader.sharedInstance.getPlacesForDiscpline("Фаст-фуд")
        XCTAssertFalse(food.isEmpty, "В массиве ничего нет")
    }

    func testTimeManager() {
        let time = timeManager.getCurrentTime(isForUser: true)
        XCTAssertFalse(time.isEmpty, "Не удалось получить время")
    }

    func testBinaryIntegerExtension() {
        let number = 2020
        let digit = number.digits[2]
        XCTAssertEqual(digit, 2, "Числа не одинаковые")
    }

    func testApplyPatternOnNumbers() {
        let digitsTime = "1130"
        let time = digitsTime.applyPatternOnNumbers(pattern: "##:##", replacmentCharacter: "#")
        XCTAssertEqual(time, "11:30", "Времена не совпадают")
    }

    func testPlaceMarkerTintColor() {
        XCTAssertEqual(place.markerTintColor, .red, "Цвета не схожи")
    }

    func testPlaceMapItem() {
        XCTAssertNotNil(place.mapItem, "Ошибка с картой")
    }
}
