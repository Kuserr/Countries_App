//
//  ListOfCountriesPresenterTests.swift
//  Countries_AppTests
//
//  Created by Сергей Курьян on 12.02.2024.
//

import XCTest
@testable import Countries_App

final class ListOfCountriesPresenterTests: XCTestCase {
    
    private var urlSession: URLSession!
    private var networkManagerProtocol: NetworkManagerProtocol!
    private let nextPage = "https://rawgit.com/page2.json"
    
    override func setUp() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLSessionProtocol.self]
        urlSession = URLSession(configuration: configuration)
        
        networkManagerProtocol = NetworkManager(urlsession: urlSession)
    }
    
    override func tearDown() {
        urlSession = nil
        networkManagerProtocol = nil
    }
    
    func test_successful_fetching_data() throws {
        let reqURL = try XCTUnwrap(URL(string: "my-iosapitest.com"), "URL must be valid!")
        let response = try XCTUnwrap (HTTPURLResponse(url: reqURL,
                                                      statusCode: 200,
                                                      httpVersion: nil,
                                                      headerFields: nil), "Response should not be nil!")
        
        let mockData: Data = Data(mockString.utf8)
        
        MockURLSessionProtocol.requestHandler = { request in
            (response, mockData)
        }
        
        let expectation = XCTestExpectation(description: "response")
        
        networkManagerProtocol.fetchData(url: reqURL) { (result: Result<CountryModel, DataError>) in
            switch result {
            case .success(let countryModel):
                XCTAssertEqual(countryModel.next, self.nextPage)
                XCTAssertEqual(countryModel.countries.count, 2)
                XCTAssertEqual(countryModel.countries.first?.capital, "Сухум" )
                
                expectation.fulfill()
            case .failure(let failure):
                XCTAssertThrowsError(failure)
            }
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func test_unsuccessful_fetching_data() throws {
        let reqURL = try XCTUnwrap(URL(string: "my-iosapitest.com"), "Url should not be nil!")
        let response = try XCTUnwrap(HTTPURLResponse(url: reqURL,
                                                     statusCode: 400,
                                                     httpVersion: nil,
                                                     headerFields: nil), "Response should not be nil!")
        
        let mockData: Data = Data(mockString.utf8)
        
        MockURLSessionProtocol.requestHandler = { request in
            (response, mockData)
        }
        
        let expectation = XCTestExpectation(description: "response")
        
        networkManagerProtocol.fetchData(url: reqURL) { (result: Result<CountryModel, DataError>) in
            switch result {
            case .success:
                XCTFail("Success closure should not be called")
            case .failure(let failure):
                XCTAssertEqual(DataError.invalidResponse, failure)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 2)
    }
}

