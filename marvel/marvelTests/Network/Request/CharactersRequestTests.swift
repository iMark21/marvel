//
//  CharactersRequestTests.swift
//  marvelTests
//
//  Created by Michel Marques on 26/9/21.
//

import XCTest

@testable import marvel

class CharactersRequestTests: XCTestCase {
    
    private var charactersRequest: CharactersRequest!

    override func setUpWithError() throws {
        try super.setUpWithError()
        charactersRequest = CharactersRequest.init(
            offset: 0,
            limit: 20
        )
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        charactersRequest = nil
    }

    func testNumberParams() {
        /// Given
        guard let url = URL.init(string: APIConstants.URL.baseUrl) else { return XCTFail("NOT BASE URL") }
        /// When
        let request = charactersRequest.request(with: url)
        
        /// Then
        XCTAssertTrue(
            request.url?.components?
                .queryItems?
                .count == 5
        )
    }
    
    func testTsParam() {
        /// Given
        guard let url = URL.init(string: APIConstants.URL.baseUrl) else { return XCTFail("NOT BASE URL") }
        /// When
        let request = charactersRequest.request(with: url)
        
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
        let request = charactersRequest.request(with: url)
        
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
        let request = charactersRequest.request(with: url)
        
        /// Then
        XCTAssertNotNil(
            request.url?.components?
                .queryItems?[APIConstants.ParamKeys.apikey]
        )
    }

}
