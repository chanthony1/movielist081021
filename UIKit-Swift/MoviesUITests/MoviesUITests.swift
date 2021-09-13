//
//  MoviesUITests.swift
//  MoviesUITests
//
//  Created by Christian Quicano on 7/09/21.
//

import XCTest

class MoviesUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app.launchArguments.append(keyLaunchMoviesScreen)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFirstRow() throws {
        // Given
        
        // When
        app.launch()
        
        // Then
        let tableView = app.tables.matching(identifier: Accessibility.MoviesList.tableView)
        let staticText = tableView.staticTexts["The Suicide Squad"]
        XCTAssertTrue(staticText.exists)
    }
    
    func testSearchBar() throws {
        // Given
        
        // When
        app.launch()
        
        // Then
        let searchBar = app.searchFields.matching(identifier: Accessibility.MoviesList.searchBar).element
        XCTAssertTrue(searchBar.exists)
        searchBar.tap()
        // insert text
        let jKey = app.keys["J"]
        jKey.tap()
        let uKey = app.keyboards.keys["u"]
        uKey.tap()
        app.keys["n"].tap()
        
        let tableView = app.tables.matching(identifier: Accessibility.MoviesList.tableView)
        let staticText = tableView.staticTexts["Jungle Cruise"]
        XCTAssertTrue(staticText.exists)
        
    }
    
    func testErrorAlert() {
        // Given
        app.launchArguments.append(keyLaunchMoviesScreenWithError)
        
        // When
        app.launch()
        
        // Then
        let errorAlert = app.alerts["Error"]
        XCTAssert(errorAlert.exists)
        let acceptButton = app.buttons["Accept"]
        XCTAssert(acceptButton.exists)
        acceptButton.tap()
        
        let searchBar = app.searchFields.matching(identifier: Accessibility.MoviesList.searchBar).element
        XCTAssertTrue(searchBar.exists)
    }

}
