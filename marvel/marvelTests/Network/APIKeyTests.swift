//
//  APIKeyTests.swift
//  marvelTests
//
//  Created by Michel Marques on 26/9/21.
//

import XCTest

@testable import marvel

class APIKeyTests: XCTestCase {
    
    private var publicKey: String!
    private var privateKey: String!

    override func setUpWithError() throws {
        try super.setUpWithError()

        publicKey = APIConstants.Keys.publicKey
        privateKey = APIConstants.Keys.privateKey
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        privateKey = nil
        publicKey = nil
    }

    func testPublicKey() {
        XCTAssertNotNil(publicKey)
        XCTAssertFalse(publicKey.isEmpty)
    }

    func testPrivateKey() throws {
        XCTAssertNotNil(privateKey)
        XCTAssertFalse(privateKey.isEmpty)
    }

}
