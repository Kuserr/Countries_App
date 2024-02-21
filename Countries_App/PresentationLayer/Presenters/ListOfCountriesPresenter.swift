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
    private let coreDataManager: CoreDataManager
    private(set) var arrayOfCountries = [Country]()
    private(set) var arrayOfCountryEntity = [CountryEntity]()
    private(set) var nextPageUrl: String = ""
    private var isOfflineMode: Bool = false
    private var countries: [Any] {
        isOfflineMode ? arrayOfCountryEntity : arrayOfCountries
    }
    
    // MARK: - Private functions
    
    private func saveToCoreData(with id: String, countryModel: Country) {
        coreDataManager.trySaveModel(with: id, countryModel: countryModel)
    }
    
    let baseURL = "https://rawgit.com/NikitaAsabin/799e4502c9fc3e0ea7af439b2dfd88fa/raw/7f5c6c66358501f72fada21e04d75f64474a7888/page1.json"
    var country: Country?
    var countryEntity: CountryEntity?
    
    init(dataService: NetworkManager, coreDataManager: CoreDataManager) {
        self.dataService = dataService
        self.coreDataManager = coreDataManager
    }
    
    typealias CompletionHandler = () -> Void
    typealias ErrorHandler = (DataError) -> Void
    
    func loadData(url: String, сompletion: @escaping CompletionHandler, errorHandler: @escaping ErrorHandler) {
        guard let baseUrl = URL(string: url) else {
            return
        }
        if NetworkMonitor.shared.isConnected {
            dataService.fetchData(url: baseUrl) { [weak self] (result: Result<CountryModel, DataError>) in
                switch result {
                case .success(let data):
                    let result = data
                    self?.isOfflineMode = false
                    self?.arrayOfCountries += result.countries
                    self?.nextPageUrl = result.next ?? ""
                    for country in result.countries {
                        self?.saveToCoreData(with: country.name, countryModel: country)
                    }
                    сompletion()
                case .failure(let error):
                    errorHandler(error)
                }
            }
        } else {
            isOfflineMode = true
            loadDataFromDatabase()
            сompletion()
        }
    }
    
    func refreshPresenter() {
        //ImageCache.shared.clearAllData()
        arrayOfCountries.removeAll()
    }
    
    func loadDataFromDatabase() {
        arrayOfCountryEntity = coreDataManager.loadCountries()
    }
    
    func decodeImagesFromData() -> [String]? {
        let imagesData = countryEntity?.images ?? Data()
        var imagesArray = [String]()
        do {
            let decoded = try JSONDecoder().decode([String].self, from: imagesData)
            imagesArray = decoded
        } catch {
            print("Error decoding data: \(error)")
        }
        return imagesArray
    }
    
    
}
