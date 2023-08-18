//
//  PhotosCell.swift
//  TestNetworking
//
//  Created by Kirill on 30.07.2023.
//

import UIKit
import SDWebImage

class PhotosCell: UICollectionViewCell {
    
    static let reuseId = "PhotosCell"
    
    private let checkMark: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark.circle")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
        return imageView
    }()
    
    let photoImageVIew : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    var unsplashPhoto : UnsplashPhoto! {
        didSet {
            let photoUrl = unsplashPhoto.urls["regular"]
            guard let imageUrl = photoUrl, let url = URL(string: imageUrl) else { return }
            photoImageVIew.sd_setImage(with: url)
            
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPhotoImageView()
        setupCheckMarkView()
        updateSelectedState()
    }
    
    //при переиспользовании сбарсываем старые данные, что бы не было видно тех картинок, которые были загружены до этого
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageVIew.image = nil
    }
    override var isSelected: Bool {
        didSet{
            updateSelectedState()
        }
    }
    
    private func updateSelectedState() {
        photoImageVIew.alpha = isSelected ? 0.7 : 1
        checkMark.alpha = isSelected ? 1 : 0
    }
    
    private func setupPhotoImageView() {
        addSubview(photoImageVIew)
        NSLayoutConstraint.activate([
            photoImageVIew.topAnchor.constraint(equalTo: topAnchor),
            photoImageVIew.bottomAnchor.constraint(equalTo: bottomAnchor),
            photoImageVIew.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoImageVIew.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    private func setupCheckMarkView() {
        addSubview(checkMark)
        NSLayoutConstraint.activate([
            checkMark.bottomAnchor.constraint(equalTo: photoImageVIew.bottomAnchor, constant: 8),
            checkMark.trailingAnchor.constraint(equalTo: photoImageVIew.trailingAnchor, constant: -8),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
