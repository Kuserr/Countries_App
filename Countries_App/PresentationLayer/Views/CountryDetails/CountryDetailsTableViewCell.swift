//
//  CountryDetailsTableViewCell.swift
//  Countries_App
//
//  Created by Сергей Курьян on 05.02.2024.
//

import UIKit

class CountryDetailsTableViewCell: UITableViewCell {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    // MARK: - Private properties
    
    private let starSymbol = "star.fill"
    private let smileSymbol = "person.3"
    private let continentSymbol = "globe.europe.africa.fill"
    private let capitalHeadline = "Capital"
    private let populationHeadline = "Headline"
    private let continentHeadline = "Continent"
    private let aboutHeadline = "About"
    
    @IBOutlet weak private var countryNameLabel: UILabel!
    @IBOutlet weak private var capitalLabel: UILabel!
    @IBOutlet weak private var countryCapitalLabel: UILabel!
    @IBOutlet weak private var populationLabel: UILabel!
    @IBOutlet weak private var countryPopulationLabel: UILabel!
    @IBOutlet weak private var continentLabel: UILabel!
    @IBOutlet weak private var countryContinentLabel: UILabel!
    @IBOutlet weak private var aboutLabel: UILabel!
    @IBOutlet weak private var countryDescriptionLabel: UILabel!
    @IBOutlet weak private var starImageView: UIImageView!
    @IBOutlet weak private var smileImageView: UIImageView!
    @IBOutlet weak private var continentImageView: UIImageView!
    
    // MARK: - Cell configuration
    
    func configure(with country: Country) {
        capitalLabel.text = capitalHeadline
        populationLabel.text = populationHeadline
        continentLabel.text = continentHeadline
        aboutLabel.text = aboutHeadline
        
        countryNameLabel.text = country.name
        countryCapitalLabel.text = country.capital
        countryPopulationLabel.text = String(country.population)
        countryContinentLabel.text = country.continent
        countryDescriptionLabel.text = country.description
        
        starImageView.image = UIImage(systemName: starSymbol)
        starImageView.tintColor = .orange
        smileImageView.image = UIImage(systemName: smileSymbol)
        smileImageView.tintColor = .orange
        continentImageView.image = UIImage(systemName: continentSymbol)
        continentImageView.tintColor = .orange
    }
}
