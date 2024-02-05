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
    private let widthLayout = CGFloat(5)
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
        presenter.loadData(url: presenter.baseURL) { [weak self] in
            self?.updateUI()
        } errorHandler: { error in
            self.showError(error: error)
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
        presenter.arrayOfCountries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: countryCollectionViewCell, for: indexPath) as? CountryCollectionViewCell
        let country = presenter.arrayOfCountries[indexPath.row]
        cell?.configure(with: country)
        return cell ?? UICollectionViewCell()
    }
}

extension ListOfCountriesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
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
        let country = presenter.arrayOfCountries[indexPath.row]
        let width = collectionView.bounds.width - widthLayout
        let minHeight: CGFloat = 230
        
        let textHeight = estimateTextHeight(country.descriptionSmall, width: width)
        
        guard textHeight.isFinite else {
            print("Invalid textHeight for indexPath: \(indexPath)")
            return CGSize(width: width, height: minHeight)
        }
        
        return CGSize(width: width, height: max(minHeight, textHeight))
    }
}

extension ListOfCountriesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard !presenter.nextPageUrl.isEmpty else {
            return .zero
        }
        return CGSize(width: collectionView.frame.width,
                      height: footerHeight)
    }
}

private extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

