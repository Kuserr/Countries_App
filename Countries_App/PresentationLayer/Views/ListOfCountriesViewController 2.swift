//
//  ListOfCountriesViewController.swift
//  Countries_App
//
//  Created by Сергей Курьян on 14.01.2024.
//

import UIKit

final class ListOfCountriesViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let presenter = ListOfCountriesPresenter(dataService: NetworkManager())
    private let countryCollectionViewCell = String(describing: CountryCollectionViewCell.self)
    private let countriesScreenTitle = "Countries"
    
    private lazy var mainCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UINib(nibName: countryCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: countryCollectionViewCell)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = countriesScreenTitle.localized
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.loadData { [weak self] in
            self?.updateUI()
        } errorHandler: { error in
            DispatchQueue.main.async {
                self.handleError(error)
            }
        }
    }
    
    // MARK: - Private functions
    
    private func estimateTextHeight(_ text: String, width: CGFloat) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16)
        ]
        
        let boundingBox = NSString(string: text).boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                                                              options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                              attributes: attributes,
                                                              context: nil)
        return ceil(boundingBox.height)
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.mainCollectionView.reloadData()
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
        presenter.arrayOfCountries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: countryCollectionViewCell, for: indexPath) as! CountryCollectionViewCell
        let country = presenter.arrayOfCountries[indexPath.row]
        cell.configure(with: country)
        return cell
    }
}

extension ListOfCountriesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let country = presenter.arrayOfCountries[indexPath.row]
        let width = collectionView.bounds.width - 5
        let minHeight: CGFloat = 230
        
        let textHeight = estimateTextHeight(country.descriptionSmall, width: width)
        
        guard textHeight.isFinite else {
            print("Invalid textHeight for indexPath: \(indexPath)")
            return CGSize(width: width, height: minHeight)
        }
        
        return CGSize(width: width, height: max(minHeight, textHeight))
    }
}

extension ListOfCountriesViewController: UICollectionViewDelegate {
}

private extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
