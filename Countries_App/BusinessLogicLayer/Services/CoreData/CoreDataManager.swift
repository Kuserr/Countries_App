//
//  CoreDataManager.swift
//  Countries_App
//
//  Created by Сергей Курьян on 13.02.2024.
//

import Foundation
import UIKit
import CoreData

final class CoreDataManager {
    
    public static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CountryDataModel")
        container.loadPersistentStores { description, error in
            if let error = error { fatalError("CountryDataModel Container failed: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    // MARK: - Private properties
    private let writeContext = CoreDataManager.persistentContainer.newBackgroundContext()
    private let readContext = CoreDataManager.persistentContainer.viewContext
    
    // MARK: - Private functions
    private func saveToDB(countryModel: Country) {
        CountryEntity.entity(with: countryModel, in: writeContext)
    }
    
    func trySaveModel(with id: String, countryModel: Country) {
        let predicate = NSPredicate(format: "id == %@", id)
        let request = CountryEntity.getAllCountryEntityRequest()
        request.predicate = predicate
        do {
            let country = try readContext.fetch(request)
            guard country.first == nil else {
                return
            }
            saveToDB(countryModel: countryModel)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadCountries() -> [CountryEntity] {
        let request = CountryEntity.getAllCountryEntityRequest()
        do {
            let countryEntityArray = try readContext.fetch(request)
            return countryEntityArray
        } catch {
            return []
        }
    }
}
