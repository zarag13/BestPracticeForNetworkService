//
//  PhotosCollectionViewController.swift
//  TestNetworking
//
//  Created by Kirill on 29.07.2023.
//

import UIKit

class PhotosCollectionViewController: UIViewController {
    
    var networkDataFetcher: NetworkDataFetcherProtocol?
    private var timer : Timer?
    private var photos = [UnsplashPhoto]()
    
    //сколько картинок в ряду
    private var itemsPerRow: CGFloat = 2
    private let secionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

    
    private var numberOfSelectedPhotos: Int {
        return collectionView.indexPathsForSelectedItems?.count ?? 0
    }
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()) //frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()
    lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped))
    }()
    @objc func addBarButtonTapped() {
        print(#function)
        
    }
    
    private var selectedImage = [UIImage]()
    lazy var actionButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionBarButtonTapped))
    }()
    @objc func actionBarButtonTapped(sender: UIBarButtonItem) {
        print(#function)
        let shareController = UIActivityViewController(activityItems: selectedImage, applicationActivities: nil)
        shareController.completionWithItemsHandler = { _, bool, _, _ in
            if bool {
                self.refresh()
            }
        }
        //что бы работало как на ipad так и на ios
        shareController.popoverPresentationController?.barButtonItem = sender
        shareController.popoverPresentationController?.permittedArrowDirections = .any
        
        present(shareController, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateNavigationButtonState()
        setupView()
    }
    
    private func updateNavigationButtonState() {
        addBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
        actionButtonItem.isEnabled = numberOfSelectedPhotos > 0
    }
    
    func refresh() {
        self.selectedImage.removeAll()
        self.collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
        updateNavigationButtonState()
    }
    
    
    func setupView() { 
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotosCell.self, forCellWithReuseIdentifier: PhotosCell.reuseId)
        self.view.addSubview(collectionView)
        collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.allowsMultipleSelection = true
        setupNavigationBar()
        setupLayout()
    }
    
    func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "PHOTOS"
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        titleLabel.textColor = #colorLiteral(red: 0.5742436647, green: 0.5705327392, blue: 0.5704542994, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.rightBarButtonItems = [actionButtonItem, addBarButtonItem]
        setupSearchBar()
    }
    
    func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    

}

extension PhotosCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            
            self.networkDataFetcher?.getDataForSearch(serachTerm: searchText) { [weak self] searchResults in
                guard let fetchPhotos = searchResults as? SearchResults else { return }
                self?.photos = fetchPhotos.results
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                    self?.refresh()
                }
            }
        })
    }
}





extension PhotosCollectionViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCell.reuseId, for: indexPath) as! PhotosCell
        let unspashPhoto = photos[indexPath.item]
        cell.unsplashPhoto = unspashPhoto
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateNavigationButtonState()
        let cell = collectionView.cellForItem(at: indexPath) as! PhotosCell
        guard let image = cell.photoImageVIew.image else { return }
        selectedImage.append(image)
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        updateNavigationButtonState()
        let cell = collectionView.cellForItem(at: indexPath) as! PhotosCell
        guard let image = cell.photoImageVIew.image else { return }
        if let index = selectedImage.firstIndex(of: image) {
            selectedImage.remove(at: index)
        }
    }
}

extension PhotosCollectionViewController : UICollectionViewDelegateFlowLayout {
    //размер конкретной ячейки
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //достаем все фотографии
        let photo = photos[indexPath.item]
        //сколько отсупов - по краям(2) и между картинками - 1 - итого будет 2 картикни
        let paddingSpace = secionInserts.left * (itemsPerRow + 1)
        //сколько ширины доступно
        let availableWidth = view.frame.width - paddingSpace
        //сколько иширины для 1 строчки
        let widthPerItem = availableWidth / itemsPerRow
        //соотноение сторон
        let height = CGFloat(photo.height) * widthPerItem / CGFloat(photo.width)
        return CGSize(width: widthPerItem, height: height)
    }
    
    //
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return secionInserts
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return secionInserts.left
    }
    
}
