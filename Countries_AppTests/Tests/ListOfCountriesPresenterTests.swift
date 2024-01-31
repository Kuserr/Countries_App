//
//  ListOfCountriesPresenterTests.swift
//  Countries_AppTests
//
//  Created by Сергей Курьян on 30.01.2024.
//

import XCTest
@testable import Countries_App

final class ListOfCountriesPresenterTests: XCTestCase {
    
    private var urlSession: URLSession!
    private var networkManagerProtocol: NetworkManagerProtocol!
    private let nextPage = "https://rawgit.com/page2.json"
    private let mockString = """
{
  "next":"https://rawgit.com/page2.json",
  "countries":[
  {
  "name": "Абхазия",
  "continent": "Eurasia",
  "capital":"Сухум",
  "population" : 243564 ,
  "description_small": "Республика Абхазия!",
  "description": "Республика Абхазия - частично признанное независимое государство. ",
  "image": "http://landmarks.ru/wp-content/uploads/2015/05/abhaziya.jpg",
  "country_info": {
     "images":[],
     "flag": "https://cdn.pixabay.com/photo/2015/10/24/21/30/abkhazia-1005013_960_720.png"
   }
  },
  {
  "name": "Гана",
  "continent": "Africa",
  "capital":"Аккра",
  "population" : 28308301 ,
  "description_small":"Республика Гана!",
  "description": "Республика Гана - государство в Западной Африке.",
  "image": "",
  "country_info": {
     "images":["http://www.tema.ru/travel/ghana/4F2C0922.jpg","https://www.novini.bg/uploads/news_pictures/2017-24/orig/bylgariq-razkriva-pochetno-konsulstvo-v-gana-452427.png"],
     "flag": "http://flags.fmcdn.net/data/flags/w580/gh.png"
   }
  }
]
}
"""
    
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
    
    func test_successful_fetching_data() {
        guard let reqURL = URL(string: "my-iosapitest.com") else { return }
        let response = HTTPURLResponse(url: reqURL,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)!
        
        let mockData: Data = Data(mockString.utf8)
        
        MockURLSessionProtocol.requestHandler = { request in
            return (response, mockData)
        }
        
        let expectation = XCTestExpectation(description: "response")
        
        networkManagerProtocol.fetchData(url: reqURL) { (result: Result<CountryModel, DataError>) in
            switch result {
            case .success(let countryModel):
                XCTAssertEqual(countryModel.next, self.nextPage)
                XCTAssertEqual(countryModel.countries.count, 2)
                
                expectation.fulfill()
            case .failure(let failure):
                XCTAssertThrowsError(failure)
            }
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func test_unsuccessful_fetching_data() {
        guard let reqURL = URL(string: "my-iosapitest.com") else { return }
        let response = HTTPURLResponse(url: reqURL,
                                       statusCode: 400,
                                       httpVersion: nil,
                                       headerFields: nil)!
        
        let mockData: Data = Data(mockString.utf8)
        
        MockURLSessionProtocol.requestHandler = { request in
            return (response, mockData)
        }
        
        let expectation = XCTestExpectation(description: "response")
        
        networkManagerProtocol.fetchData(url: reqURL) { (result: Result<CountryModel, DataError>) in
            switch result {
            case .success:
                XCTAssertThrowsError("Fatal Error")
            case .failure(let failure):
                XCTAssertEqual(DataError.invalidResponse, failure)
                                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 2)
    }
}
