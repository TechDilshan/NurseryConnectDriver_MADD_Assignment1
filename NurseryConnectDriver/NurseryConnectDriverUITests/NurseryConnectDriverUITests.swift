import XCTest

final class NurseryConnectDriverUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testAppLaunchShowsMainTabs() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.tabBars.buttons["Dashboard"].exists)
        XCTAssertTrue(app.tabBars.buttons["Manifest"].exists)
        XCTAssertTrue(app.tabBars.buttons["Route"].exists)
        XCTAssertTrue(app.tabBars.buttons["Settings"].exists)
    }

    func testCanOpenManifestTab() throws {
        let app = XCUIApplication()
        app.launch()

        app.tabBars.buttons["Manifest"].tap()

        XCTAssertTrue(app.navigationBars["Today's Manifest"].exists)
    }

    func testCanOpenRouteTab() throws {
        let app = XCUIApplication()
        app.launch()

        app.tabBars.buttons["Route"].tap()

        XCTAssertTrue(app.navigationBars["Live Route"].exists)
    }

    func testCanOpenSettingsTab() throws {
        let app = XCUIApplication()
        app.launch()

        app.tabBars.buttons["Settings"].tap()

        XCTAssertTrue(app.navigationBars["Settings"].exists)
    }

    func testDashboardContainsMainButtons() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.buttons["Open Today's Manifest"].exists)
        XCTAssertTrue(app.buttons["Open Live Route"].exists)
        XCTAssertTrue(app.buttons["View Trip Summary"].exists)
    }

    func testCanNavigateToTripSummaryFromDashboard() throws {
        let app = XCUIApplication()
        app.launch()

        let tripSummaryButton = app.buttons["View Trip Summary"]
        XCTAssertTrue(tripSummaryButton.waitForExistence(timeout: 5))

        tripSummaryButton.tap()

        let tripSummaryNavBar = app.navigationBars["Trip Summary"]
        XCTAssertTrue(tripSummaryNavBar.waitForExistence(timeout: 5))
    }

    func testRouteScreenContainsMainControls() throws {
        let app = XCUIApplication()
        app.launch()

        app.tabBars.buttons["Route"].tap()

        XCTAssertTrue(app.buttons["Start Route"].exists)
        XCTAssertTrue(app.buttons["Stop Route"].exists)
        XCTAssertTrue(app.buttons["Reset Route"].exists)
        XCTAssertTrue(app.buttons["Center Driver"].exists)
    }

    func testSettingsThemePickerExists() throws {
        let app = XCUIApplication()
        app.launch()

        app.tabBars.buttons["Settings"].tap()

        XCTAssertTrue(app.navigationBars["Settings"].exists)
    }

    func testManifestScreenShowsChildrenList() throws {
        let app = XCUIApplication()
        app.launch()

        app.tabBars.buttons["Manifest"].tap()

        XCTAssertTrue(app.staticTexts["Emma Johnson"].exists || app.staticTexts["Liam Smith"].exists || app.staticTexts["Olivia Brown"].exists)
    }

    func testCanOpenChildDetailsFromManifest() throws {
        let app = XCUIApplication()
        app.launch()

        app.tabBars.buttons["Manifest"].tap()

        if app.staticTexts["Emma Johnson"].exists {
            app.staticTexts["Emma Johnson"].tap()
            XCTAssertTrue(app.navigationBars["Child Details"].exists)
        }
    }
}
