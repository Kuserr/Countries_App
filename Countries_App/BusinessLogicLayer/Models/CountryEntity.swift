//
//  CountryEntity.swift
//  Countries_App
//
//  Created by Сергей Курьян on 13.02.2024.
//

import Foundation
import CoreData

final class CountryEntity: NSManagedObject {
    
    @NSManaged public var capital: String
    @NSManaged public var continent: String
    @NSManaged public var descriptionFull: String
    @NSManaged public var descriptionSmall: String
    @NSManaged public var flag: String
    @NSManaged public var id: String
    @NSManaged public var image: String
    @NSManaged public var name: String
    @NSManaged public var population: Int32
    @NSManaged public var images: Data
    
    static func entity(with countryModel: Country, in context: NSManagedObjectContext) {
        let country = CountryEntity(context: context)
        country.image = countryModel.image
        country.continent = countryModel.continent
        country.population = Int32(countryModel.population)
        country.capital = countryModel.capital
        country.name = countryModel.name
        country.descriptionFull = countryModel.description
        country.descriptionSmall = countryModel.descriptionSmall
        country.flag = countryModel.countryInfo.flag
        country.id = countryModel.name
        do {
            let imageData = try JSONEncoder().encode(countryModel.countryInfo.images)
            country.images = imageData
            try context.save()
        } catch {
            print("Failed to save data to Container: \(error)")
        }
    }
    
    static func getAllCountryEntityRequest() -> NSFetchRequest<CountryEntity> {
        return NSFetchRequest<CountryEntity>(entityName: String(describing: CountryEntity.self))
    }
}

extension CountryEntity: CountryRepresentable {}
