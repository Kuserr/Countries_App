//
//  CountryDetailsViewController.swift
//  Countries_App
//
//  Created by Сергей Курьян on 01.02.2024.
//

import UIKit

final class CountryDetailsViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let presenter = ListOfCountriesPresenter(dataService: NetworkManager())
    private let countryImagesCollectionViewCell = String(describing: CountryImagesCollectionViewCell.self)
    private let countryDetailsTableViewCell = String(describing: CountryDetailsTableViewCell.self)
    private let collectionViewWidth = UIScreen.main.bounds.width
    private let collectionViewHeight = CGFloat(300)
    private let numberOfTableViewCells = 1
    
    private lazy var mainCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UINib(nibName: countryImagesCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: countryImagesCollectionViewCell)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        
        return collectionView
    }()
    
    private lazy var tableView: UITableView = {
        
        let tableView = UITableView()
        tableView.register(UINib(nibName: countryDetailsTableViewCell, bundle: nil), forCellReuseIdentifier: countryDetailsTableViewCell)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isScrollEnabled = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainCollectionView.contentInsetAdjustmentBehavior = .never
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainCollectionView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: collectionViewHeight)
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        var insets = view.safeAreaInsets
        insets.top = 0
        insets.bottom = 0
        mainCollectionView.contentInset = insets
    }
}

// MARK: - Extensions for view configuration

private extension CountryDetailsViewController {
    func setup() {
        view.addSubview(mainCollectionView)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            mainCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            mainCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainCollectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight),
            
            tableView.topAnchor.constraint(equalTo: mainCollectionView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK: - Extensions for CollectionView

extension CountryDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let country = presenter.country else {
            return 0
        }
        return country.countryInfo.images.isEmpty ? 1 : country.countryInfo.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: countryImagesCollectionViewCell, for: indexPath) as? CountryImagesCollectionViewCell
        
        if let images = presenter.country?.countryInfo.images, !images.isEmpty {
            if indexPath.item < images.count {
                let image = images[indexPath.item]
                guard let flagURL = presenter.country?.countryInfo.flag, let pages = presenter.country?.countryInfo.images.count else {
                    return UICollectionViewCell()
                }
                cell?.configure(with: image, flagURL: flagURL, numberOfPages: pages, imageIndex: indexPath.item)
            } else {
                cell?.configure(with: "", flagURL: "", numberOfPages: 0, imageIndex: 0)
            }
        } else {
            guard let flaURL = presenter.country?.countryInfo.flag else { return UICollectionViewCell()}
            cell?.configure(with: "", flagURL: flaURL, numberOfPages: 0, imageIndex: 0)
        }
        return cell ?? UICollectionViewCell()
    }
}

extension CountryDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insets = collectionView.contentInset
        let itemWidth = collectionViewWidth - insets.left - insets.right
        let itemHeight = collectionViewHeight - insets.top - insets.bottom
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

// MARK: - Extensions for TableView

extension CountryDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfTableViewCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: countryDetailsTableViewCell, for: indexPath) as? CountryDetailsTableViewCell
        if let country = presenter.country {
            cell?.configure(with: country)
        }
        return cell ?? UITableViewCell()
    }
}

extension CountryDetailsViewController: UITableViewDelegate {
}

