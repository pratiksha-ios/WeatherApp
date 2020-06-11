//
//  AlertTests.swift
//  WeatherAppTests
//
//  Created by Admin on 2020/06/09.
//  Copyright © 2020 Admin. All rights reserved.
//

import XCTest
@testable import WeatherApp

class AlertTests: XCTestCase {
    
    func testAlert() {
        let expectAlertActionHandlerCall = expectation(description: "Alert action handler called")
        let alert = SingleButtonAlert(
            title: "",
            message: "",
            action: AlertAction(buttonTitle: "", handler: {
                expectAlertActionHandlerCall.fulfill()
            })
        )
        alert.action.handler!()
        waitForExpectations(timeout: 0.1, handler: nil)
    }
}
