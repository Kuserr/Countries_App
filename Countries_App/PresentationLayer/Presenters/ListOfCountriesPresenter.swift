//
//  ListOfCountriesPresenter.swift
//  Countries_App
//
//  Created by Сергей Курьян on 14.01.2024.
//

import Foundation

final class ListOfCountriesPresenter {
    
    // MARK: - Private property
    
    private let dataService: NetworkManager
    private(set) var arrayOfCountries = [Country]()
    private(set) var nextPageUrl: String = ""
    
    let baseURL = "https://rawgit.com/NikitaAsabin/799e4502c9fc3e0ea7af439b2dfd88fa/raw/7f5c6c66358501f72fada21e04d75f64474a7888/page1.json"
    
    init(dataService: NetworkManager) {
        self.dataService = dataService
    }
    
    typealias CompletionHandler = () -> Void
    typealias ErrorHandler = (DataError) -> Void
    
    func loadData(url: String, сompletion: @escaping CompletionHandler, errorHandler: @escaping ErrorHandler) {
        guard let baseUrl = URL(string: url) else {
            return
        }
        dataService.fetchData(url: baseUrl) { [weak self] (result: Result<CountryModel, DataError>) in
            switch result {
            case .success(let data):
                let result = data
                self?.arrayOfCountries += result.countries
                self?.nextPageUrl = result.next ?? ""
                сompletion()
            case .failure(let error):
                errorHandler(error)
            }
        }
    }
    
    func refreshPresenter() {
        CountryCollectionViewCell.imageCache.removeAllObjects()
        arrayOfCountries.removeAll()
    }
}
