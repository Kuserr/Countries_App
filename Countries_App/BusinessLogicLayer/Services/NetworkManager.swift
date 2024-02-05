//
//  NetworkManager.swift
//  Countries_App
//
//  Created by Сергей Курьян on 12.01.2024.
//

import Foundation

enum DataError: Error, Equatable {
    
    case invalidData
    case invalidResponse
    case message(_ error: Error)
    
    static func == (lhs: DataError, rhs: DataError) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
}

protocol NetworkManagerProtocol {
    func fetchData<T: Decodable>(url: URL, completion: @escaping ModelCallback<T>)
    var urlSession: URLSession { get }
}

typealias ModelCallback<T: Decodable> = (Result<T, DataError>) -> Void

final class NetworkManager: NetworkManagerProtocol {
    
    var urlSession: URLSession
    
    init(urlsession: URLSession) {
        self.urlSession = urlsession
    }
    
    func fetchData<T: Decodable>(url: URL, completion: @escaping ModelCallback<T>) {
        
        urlSession.dataTask(with: url) { data, response, error in
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
                let countries = try decoder.decode(T.self, from: data)
                completion(.success(countries))
            }
            catch {
                completion(.failure(.message(error)))
            }
        }.resume()
    }
}
