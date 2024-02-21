//
//  CountryDetailsTableViewCell.swift
//  Countries_App
//
//  Created by Сергей Курьян on 05.02.2024.
//

import UIKit

final class CountryDetailsTableViewCell: UITableViewCell {
    
    // MARK: - Private properties
    
    private let capitalHeadline = "Capital"
    private let populationHeadline = "Population"
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
    
    override func awakeFromNib() {
        starImageView.image = UIImage(systemName: "star.fill")
        starImageView.tintColor = .orange
        smileImageView.image = UIImage(systemName: "person.3")
        smileImageView.tintColor = .orange
        continentImageView.image = UIImage(systemName: "globe.europe.africa.fill")
        continentImageView.tintColor = .orange
    }
    
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
    }
    
    func configureForCoreData(with countryEntity: CountryEntity) {
        capitalLabel.text = capitalHeadline
        populationLabel.text = populationHeadline
        continentLabel.text = continentHeadline
        aboutLabel.text = aboutHeadline
        
        countryNameLabel.text = countryEntity.name
        countryCapitalLabel.text = countryEntity.capital
        countryPopulationLabel.text = String(countryEntity.population)
        countryContinentLabel.text = countryEntity.continent
        countryDescriptionLabel.text = countryEntity.descriptionFull
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
