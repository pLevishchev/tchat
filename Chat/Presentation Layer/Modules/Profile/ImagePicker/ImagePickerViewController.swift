//
//  ImagePickerViewController.swift
//  Chat
//
//  Created by Павел Левищев on 20.11.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import UIKit

class ImagePickerViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    private let spacing: CGFloat = 10.0
    var pickImageCallback: ((UIImage) -> Void)?
    let coreAssembly = CoreAssembly()

    private var activityIndicator = UIActivityIndicatorView(style: .gray)

    // Dependencies
    private let presentationAssembly: IPresentationAssembly
    private let serviceAssembly: IServicesAssembly
    private var imageData: [ImageDataModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    init(presentationAssembly: IPresentationAssembly, serviceAssembly: IServicesAssembly) {
        self.presentationAssembly = presentationAssembly
        self.serviceAssembly = serviceAssembly
        self.imageData = []
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(activityIndicator)
        getImagesData()
        self.collectionView!.register(UINib(nibName: ImagePickerCollectionViewCell.reuseID, bundle: nil),
                                      forCellWithReuseIdentifier: ImagePickerCollectionViewCell.reuseID)
        collectionView.delegate = self
        configLayout()
        configactivityIndicator()
    }
    
    func getImagesData() {
        coreAssembly.requestSender.getImagesData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let images):
                self.imageData.append(contentsOf: images)
            case .failure(let error):
                self.presentAlertOnMainThread(title: "Что-то пошло не так",
                                              message: error.localizedDescription,
                                              type: .fail)
            }
        }
    }
    
    func configactivityIndicator() {
        activityIndicator.center = view.center
        activityIndicator.color = .black
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
}

extension ImagePickerViewController {
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return imageData.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: ImagePickerCollectionViewCell.reuseID,
                                     for: indexPath) as? ImagePickerCollectionViewCell
        else {
            fatalError("Wrong cell")
        }
             
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 willDisplay cell: UICollectionViewCell,
                                 forItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        }
        
        coreAssembly.downloadImage.downloadImage(from: imageData[indexPath.item].largeImageURL) { image in
            guard let newCell = cell as? ImagePickerCollectionViewCell else { fatalError("Wrong cell") }
            DispatchQueue.main.async {
                newCell.update(image: image ?? UIImage())
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 3
        let spacingBetweenCells: CGFloat = 10
        
        let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells)
        
        if let collection = self.collectionView {
            let width = (collection.bounds.width - totalSpacing) / numberOfItemsPerRow
            return CGSize(width: width, height: width)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        coreAssembly.downloadImage.downloadImage(from: imageData[indexPath.item].largeImageURL) { [weak self] image in
            guard let self = self else { return }
            self.pickImageCallback?(image ?? UIImage())
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func configLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.collectionView?.collectionViewLayout = layout
    }
}
