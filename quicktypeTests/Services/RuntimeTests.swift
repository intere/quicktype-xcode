//
//  RuntimeTests.swift
//  quicktypeTests
//
//  Created by Eric Internicola on 6/10/23.
//  Copyright © 2023 quicktype. All rights reserved.
//

@testable import quicktype
import XCTest

final class RuntimeTests: XCTestCase {

    let subject = Runtime.shared

    override func setUpWithError() throws {
        try super.setUpWithError()
        if !subject.isInitialized {
            XCTAssertTrue(subject.initialize())
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGenerateCpp() async throws {
        let actual = try await subject.quicktype(referenceJSON, topLevel: "Pocppo", language: .cpp, options: [:])
        XCTAssertNotNil(actual)
    }

    func testGenerateJava() async throws {
        let actual = try await subject.quicktype(referenceJSON, topLevel: "Pojo", language: .java, options: [:])
        XCTAssertNotNil(actual)
    }

    func testGenerateObjc() async throws {
        let actual = try await subject.quicktype(referenceJSON, topLevel: "Pooco", language: .objc, options: [:])
        XCTAssertNotNil(actual)
    }

    func testGenerateObjcHeader() async throws {
        let actual = try await subject.quicktype(referenceJSON, topLevel: "Pooco", language: .objcHeader, options: [:])
        XCTAssertNotNil(actual)
    }

    func testGenerateSwift() async throws {
        let actual = try await subject.quicktype(referenceJSON, topLevel: "Poso", language: .swift, options: [:])
        XCTAssertNotNil(actual)
    }



}

// MARK: - Implementation

private extension RuntimeTests {
    var referenceJSON: String {
"""
{"object":"catalog","total_values":20,"data":["Sol Ring","Soliton","Sol Grail","Solarion","Solitude","Solar Tide","Solfatara","Solemnity","Solar Blaze","Solar Blast","Solidarity","Soldevi Sage","Soltari Monk","Sol Talisman","Soldevi Golem","Solid Footing","Solemn Recruit","Soldevi Sentry","Soldevi Adnate","Soldevi Digger"]}
"""
    }
}
