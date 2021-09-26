//
//  ComicsRequestTests.swift
//  marvelTests
//
//  Created by Michel Marques on 26/9/21.
//

import XCTest

@testable import marvel

class ComicsRequestTests: XCTestCase {
    
    private var request: ComicsRequest!
    private var characterId: Int!

    override func setUpWithError() throws {
        try super.setUpWithError()
        characterId = 123456
        request = ComicsRequest.init(characterId: characterId)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        request = nil
        characterId = nil
    }
    
    func testContainsCharacterId() {
        /// Given
        guard let url = URL.init(string: APIConstants.URL.baseUrl) else { return XCTFail("NOT BASE URL") }
        /// When
        let request = request.request(with: url)
        
        /// Then
        XCTAssertTrue(
            (request.url!.path
                .contains(
                    String(characterId)
                )
            )
        )
    }

    func testNumberParams() {
        /// Given
        guard let url = URL.init(string: APIConstants.URL.baseUrl) else { return XCTFail("NOT BASE URL") }
        /// When
        let request = request.request(with: url)
        
        /// Then
        XCTAssertTrue(
            request.url?.components?
                .queryItems?
                .count == 3
        )
    }
    
    func testTsParam() {
        /// Given
        guard let url = URL.init(string: APIConstants.URL.baseUrl) else { return XCTFail("NOT BASE URL") }
        /// When
        let request = request.request(with: url)
        
        /// Then
        XCTAssertNotNil(
            request.url?.components?
                .queryItems?[APIConstants.ParamKeys.ts]
        )
    }
    
    func testHashParam() {
        /// Given
        guard let url = URL.init(string: APIConstants.URL.baseUrl) else { return XCTFail("NOT BASE URL") }
        /// When
        let request = request.request(with: url)
        
        /// Then
        XCTAssertNotNil(
            request.url?.components?
                .queryItems?[APIConstants.ParamKeys.hash]
        )
    }
    
    func testApiKeyParam() {
        /// Given
        guard let url = URL.init(string: APIConstants.URL.baseUrl) else { return XCTFail("NOT BASE URL") }
        /// When
        let request = request.request(with: url)
        
        /// Then
        XCTAssertNotNil(
            request.url?.components?
                .queryItems?[APIConstants.ParamKeys.apikey]
        )
    }

}
