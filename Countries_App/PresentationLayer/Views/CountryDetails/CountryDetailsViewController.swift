//
//  CountryDetailsViewController.swift
//  Countries_App
//
//  Created by Сергей Курьян on 01.02.2024.
//

import UIKit

final class CountryDetailsViewController: UIViewController {
    
    var country: Country?
    private let presenter = ListOfCountriesPresenter(dataService: NetworkManager())
    private let countryImagesCollectionViewCell = String(describing: CountryImagesCollectionViewCell.self)
    private let collectionViewWidth = UIScreen.main.bounds.width
    private let collectionViewHeight = CGFloat(300)
    
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

private extension CountryDetailsViewController {
    func setup() {
        view.addSubview(mainCollectionView)
        
        NSLayoutConstraint.activate([
            mainCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            mainCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension CountryDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let country = country else {
            return 0
        }
        return country.countryInfo.images.isEmpty ? 1 : country.countryInfo.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: countryImagesCollectionViewCell, for: indexPath) as? CountryImagesCollectionViewCell
    
        if let images = country?.countryInfo.images, !images.isEmpty {
            if indexPath.item < images.count {
                let image = images[indexPath.item]
                guard let flagURL = country?.countryInfo.flag, let pages = country?.countryInfo.images.count else {
                    return UICollectionViewCell()
                }
                cell?.configure(with: image, flagURL: flagURL, numberOfPages: pages, imageIndex: indexPath.item)
            } else {
                cell?.configure(with: "", flagURL: "", numberOfPages: 0, imageIndex: 0)
            }
        } else {
            guard let flaURL = country?.countryInfo.flag else { return UICollectionViewCell()}
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

