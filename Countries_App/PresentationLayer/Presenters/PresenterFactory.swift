//
//  PresenterFactory.swift
//  Countries_App
//
//  Created by Сергей Курьян on 05.02.2024.
//

import Foundation

struct PresenterFactory {
    static func listOfCountriesPresenter() -> ListOfCountriesPresenter {
        ListOfCountriesPresenter(dataService: NetworkManager(urlsession: URLSession.shared))
    }
}
