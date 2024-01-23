//
//  ListOfCountriesPresenter.swift
//  Countries_App
//
//  Created by Сергей Курьян on 14.01.2024.
//

import Foundation

final class ListOfCountriesPresenter {
    
    // MARK: - Private properties
    
    private let dataService: NetworkManager
    
    var arrayOfCountries = [Country]()
    
    init(dataService: NetworkManager) {
        self.dataService = dataService
    }
    
    typealias CompletionHandler = () -> Void
    typealias ErrorHandler = (DataError) -> Void
    
    func loadData(сompletion: @escaping CompletionHandler, errorHandler: @escaping ErrorHandler) {
        guard let baseUrl = URL(string: "https://rawgit.com/NikitaAsabin/799e4502c9fc3e0ea7af439b2dfd88fa/raw/7f5c6c66358501f72fada21e04d75f64474a7888/page1.json") else {return}
        dataService.fetchData(url: baseUrl) { [weak self] (result: Result<CountryModel, DataError>) in
            switch result {
            case .success(let data):
                let countries = data.countries
                self?.arrayOfCountries = countries
                сompletion()
            case .failure(let error):
                errorHandler(error)
            }
        }
    }
}
