//
//  NetworkManager.swift
//  Countries_App
//
//  Created by Сергей Курьян on 12.01.2024.
//

import Foundation

enum DataError: Error {
    case invalidData
    case invalidResponse
    case message(_ error: Error?)
}

typealias CountryModelCallback = (Result<CountryModel, DataError>) -> Void

final class NetworkManager {
    
    init() {}
    
    private let url = URL(string: "https://rawgit.com/NikitaAsabin/799e4502c9fc3e0ea7af439b2dfd88fa/raw/7f5c6c66358501f72fada21e04d75f64474a7888/page1.json")!
    
    func fetchData(completion: @escaping CountryModelCallback) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data else {
                completion(.failure(.invalidData))
                return
            }
            guard let response = response as? HTTPURLResponse, 200 ... 299  ~= response.statusCode else {
            completion(.failure(.invalidResponse))
            return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let countries = try decoder.decode(CountryModel.self, from: data)
                completion(.success(countries))
            }
            catch {
                completion(.failure(.message(error)))
            }
        }.resume()
    }
}
