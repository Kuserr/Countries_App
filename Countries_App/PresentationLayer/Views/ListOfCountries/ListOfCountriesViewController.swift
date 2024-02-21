//
//  ListOfCountriesViewController.swift
//  Countries_App
//
//  Created by Сергей Курьян on 14.01.2024.
//

import UIKit

final class ListOfCountriesViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let presenter = PresenterFactory.listOfCountriesPresenter()
    private let countryCollectionViewCell = String(describing: CountryCollectionViewCell.self)
    private let countriesScreenTitle = "Countries"
    private let footerCollectionReusableView = String(describing: FooterLoadingCollectionReusableView.self)
    private var refreshControl = UIRefreshControl()
    private let footerHeight = CGFloat(100)
    
    private lazy var mainCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UINib(nibName: countryCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: countryCollectionViewCell)
        collectionView.register(FooterLoadingCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: footerCollectionReusableView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.addSubview(refreshControl)
        return collectionView
    }()
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = countriesScreenTitle.localized
        setup()
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
    // MARK: - Private functions
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.mainCollectionView.reloadData()
        }
    }
    
    private func updateUIAfterRefreshing() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.mainCollectionView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    private func showError(error: DataError) {
        DispatchQueue.main.async {
            self.handleError(error)
        }
    }
    
    private func loadNextPage() {
        guard !presenter.nextPageUrl.isEmpty else {
            return
        }
        presenter.loadData(url: presenter.nextPageUrl) { [weak self] in
            self?.updateUI()
        } errorHandler: { error in
            self.showError(error: error)
        }
    }
    
    private func loadData() {
        presenter.refreshPresenter()
        presenter.loadData(url: presenter.baseURL) { [weak self] in
            self?.updateUI()
        } errorHandler: { error in
            self.showError(error: error)
        }
    }
    
    @objc private func refresh(send: UIRefreshControl) {
        presenter.refreshPresenter()
        presenter.loadData(url: presenter.baseURL) { [weak self] in
            self?.updateUIAfterRefreshing()
        } errorHandler: { error in
            self.showError(error: error)
        }
    }
    
    // MARK: - Error Handling
    
    private func handleError(_ error: DataError) {
        switch error {
        case .invalidData:
            showAlert(title: "Error", message: "Invalid Data")
        case .invalidResponse:
            showAlert(title: "Error", message: "Invalid Response")
        case .message(let errorMessage):
            showAlert(title: "Error", message: errorMessage.localizedDescription)
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - ListOfCountriesViewController Functionality extensions

private extension ListOfCountriesViewController {
    func setup() {
        view.addSubview(mainCollectionView)
        NSLayoutConstraint.activate([
            mainCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            mainCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ListOfCountriesViewController:  UICollectionViewDataSource  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if NetworkMonitor.shared.isConnected {
            return presenter.arrayOfCountries.count
        } else {
            return presenter.arrayOfCountryEntity.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: countryCollectionViewCell, for: indexPath) as? CountryCollectionViewCell
        
        if NetworkMonitor.shared.isConnected {
            let country = presenter.arrayOfCountries[indexPath.row]
            cell?.configure(with: country)
        } else {
            let countryEntity = presenter.arrayOfCountryEntity[indexPath.row]
            cell?.configure(with: countryEntity)
        }
        
        return cell ?? UICollectionViewCell()
    }
}

extension ListOfCountriesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard NetworkMonitor.shared.isConnected else {
            return
        }
        
        guard indexPath.row == presenter.arrayOfCountries.count - 1, !presenter.nextPageUrl.isEmpty else {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.loadNextPage()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter,
              let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                           withReuseIdentifier: footerCollectionReusableView,
                                                                           for: indexPath
              ) as? FooterLoadingCollectionReusableView
        else {
            return UICollectionReusableView()
        }
        if !presenter.nextPageUrl.isEmpty {
            footer.startAnimating()
        } else {
            footer.stopAnimating()
        }
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let country: CountryRepresentable
        if !presenter.arrayOfCountries.isEmpty {
            country = presenter.arrayOfCountries[indexPath.row]
        } else if !presenter.arrayOfCountryEntity.isEmpty {
            country = presenter.arrayOfCountryEntity[indexPath.row]
        } else {
            return CGSize(width: collectionView.bounds.width, height: 100)
        }
        
        return CGSize(width: collectionView.bounds.width, height: country.textHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCountry: CountryRepresentable
        if NetworkMonitor.shared.isConnected {
            selectedCountry = presenter.arrayOfCountries[indexPath.item]
        } else {
            selectedCountry = presenter.arrayOfCountryEntity[indexPath.item]
        }
        
        let countryDetailsViewController = CountryDetailsViewController()
        if let countryData = selectedCountry as? Country {
            countryDetailsViewController.presenter.country = countryData
        } else if let countryEntity = selectedCountry as? CountryEntity {
            countryDetailsViewController.presenter.countryEntity = countryEntity
        }
        
        navigationController?.pushViewController(countryDetailsViewController, animated: true)
    }
}

extension ListOfCountriesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if NetworkMonitor.shared.isConnected {
            guard !presenter.nextPageUrl.isEmpty else {
                return .zero
            }
            return CGSize(width: collectionView.frame.width, height: footerHeight)
        } else {
            return .zero
        }
    }
}

private extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

