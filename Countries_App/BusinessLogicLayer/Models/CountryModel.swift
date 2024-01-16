//
//  CountryModel.swift
//  Countries_App
//
//  Created by Сергей Курьян on 12.01.2024.
//

import Foundation

// MARK: - CountryModel
struct CountryModel: Codable {
    let next: String
    let countries: [Country]
}

// MARK: - Country
struct Country: Codable {
    let name, continent, capital: String
    let population: Int
    let descriptionSmall, description: String
    let image: String
    let countryInfo: CountryInfo
}

// MARK: - CountryInfo
struct CountryInfo: Codable {
    let images: [String]
    let flag: String
}

