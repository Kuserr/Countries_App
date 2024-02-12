//
//  NetworkManagerTests.swift
//  Countries_AppTests
//
//  Created by Сергей Курьян on 12.02.2024.
//

import XCTest
@testable import Countries_App

final class NetworkManagerTests: XCTestCase {
    
    private var networkManager: NetworkManager!
    
    override func setUp() {
        super.setUp()
        networkManager = NetworkManager(urlsession: URLSession.shared)
    }
    
    override func tearDown() {
        networkManager = nil
        super.tearDown()
    }
    
    func test_successful_data_fetching() throws {
        let expectation = XCTestExpectation(description: "Fetching data successfully")
        let url = try XCTUnwrap(URL(string: "https://rawgit.com/NikitaAsabin/799e4502c9fc3e0ea7af439b2dfd88fa/raw/7f5c6c66358501f72fada21e04d75f64474a7888/page1.json"), "URL should be valid!")
        
        networkManager.fetchData(url: url) { (result: Result<CountryModel, DataError>) in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to fetch data with error: \(error)")
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_fetching_data_with_error() throws {
        let expectation = XCTestExpectation(description: "Error handling test")
        
        let url = try XCTUnwrap(URL(string: "example.com"), "You should not be nil.")
        
        networkManager.fetchData(url: url) { (result: Result<CountryModel, DataError>) in
            switch result {
            case .success:
                XCTFail("Fetching data should fail with invalid URL")
            case .failure(let error):
                XCTAssertEqual(error, DataError.invalidData)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
}

