//
//  CountryModel.swift
//  Countries_App
//
//  Created by Сергей Курьян on 12.01.2024.
//

import Foundation

// MARK: - CountryModel
struct CountryModel: Decodable {
    let next: String?
    let countries: [Country]
}

// MARK: - Country
struct Country: Decodable {
    let name, continent, capital: String
    let population: Int
    let descriptionSmall, description: String
    let image: String
    let countryInfo: CountryInfo
}

extension Country: CountryRepresentable {}

// MARK: - CountryInfo
struct CountryInfo: Decodable {
    let images: [String]
    let flag: String
}


