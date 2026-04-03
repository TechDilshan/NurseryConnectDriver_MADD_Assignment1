//
//  NurseryConnectDriverUITestsLaunchTests.swift
//  NurseryConnectDriverUITests
//
//  Created by chamika dilshan on 2026-04-01.
//

import XCTest

final class NurseryConnectDriverUITestsLaunchTests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testAppLaunchShowsDashboard() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.navigationBars["Dashboard"].exists || app.tabBars.firstMatch.exists)
    }
}
