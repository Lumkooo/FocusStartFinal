//
//  FocusStartProjectUITests.swift
//  FocusStartProjectUITests
//
//  Created by Андрей Шамин on 12/7/20.
//

import XCTest

class FocusStartProjectUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPlacesCollectionView() throws {
        let collectionView = app.collectionViews["placesCollectionView"]
        collectionView.accessibilityScroll(.left)
        collectionView.accessibilityScroll(.right)
        XCTAssertTrue(collectionView.exists)
    }

    func testNearestPlacesLabel() throws {
        let label = app.staticTexts["nearestPlacesLabel"]
        XCTAssertTrue(label.exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
