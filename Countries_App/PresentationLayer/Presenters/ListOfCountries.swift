//
//  ListOfCountries.swift
//  Countries_App
//
//  Created by Сергей Курьян on 14.01.2024.
//

import Foundation

final class ListOfCountries {
    
    let dataService: NetworkManager
    @Published var listOfCountries = [Country]()
    
    init(dataService: NetworkManager) {
        self.dataService = dataService
        fetchData()
    }
    
    func fetchData() {
        dataService.fetchData { [weak self] result in
            switch result {
            case .success(let data):
                let result = data
                print("\(result)")
                self?.listOfCountries = result.countries
            case .failure(let error):
                print(error.localizedDescription)
            }
            }
        }
}
