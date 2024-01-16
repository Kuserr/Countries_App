//
//  MainVC.swift
//  Countries_App
//
//  Created by Сергей Курьян on 14.01.2024.
//

import UIKit

class MainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Countries"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dataService.fetchData()
        setup()
        mainCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataService.listOfCountries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: CountryCollectionViewCell.reuseId, for: indexPath) as! CountryCollectionViewCell
        let country = dataService.listOfCountries[indexPath.row]
            cell.configure(with: country)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let country = dataService.listOfCountries[indexPath.row]
        let width = collectionView.bounds.width - 5
        let minHeight: CGFloat = 230

        let textHeight = estimateTextHeight(country.descriptionSmall, width: width)

        // Обработайте случай нулевых или бесконечных размеров
        guard textHeight.isFinite else {
            print("Invalid textHeight for indexPath: \(indexPath)")
            return CGSize(width: width, height: minHeight)
    }

        return CGSize(width: width, height: max(minHeight, textHeight))
    }

    // MARK: - Private
    private let dataService = ListOfCountries(dataService: NetworkManager())
    
    private lazy var mainCollectionView: UICollectionView = {
    
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    
        let vw = UICollectionView(frame: .zero, collectionViewLayout: layout)
        vw.register(UINib(nibName: "CountryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CountryCollectionViewCell.reuseId)
        //vw.isEditing = true
        vw.dataSource = self
        vw.delegate = self
        vw.translatesAutoresizingMaskIntoConstraints = false
        return vw
    }()
    
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
}

private extension MainVC {
    func setup() {
        self.view.addSubview(mainCollectionView)
        NSLayoutConstraint.activate([
            mainCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            mainCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mainCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            mainCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}
