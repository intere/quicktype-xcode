//
//  LanguageTests.swift
//  quicktypeTests
//
//  Created by Eric Internicola on 6/10/23.
//  Copyright © 2023 quicktype. All rights reserved.
//

@testable import quicktype
import XCTest

final class LanguageTests: XCTestCase {

    func testSwift() throws {
        let swiftUtiString = "public.swift-source"
        let actual = Language.languageFor(contentUTI: swiftUtiString)
        XCTAssertEqual(.swift, actual)
    }

}
