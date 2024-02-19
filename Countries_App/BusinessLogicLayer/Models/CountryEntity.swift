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
    
    static func getAllCountryEntityRequest() -> NSFetchRequest<CountryEntity> {
        return NSFetchRequest<CountryEntity>(entityName: String(describing: CountryEntity.self))
    }
}
