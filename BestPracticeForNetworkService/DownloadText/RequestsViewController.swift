//
//  RequestsViewController.swift
//  BestPracticeForNetworkService
//
//  Created by Kirill on 18.08.2023.
//

import UIKit

class RequestsViewController: UIViewController {
    
    var networkManager: NetworkBulderProtocol = PostsNetworkBulder()
    
    let getButton: UIButton = {
        let button = UIButton()
        button.setTitle("Get", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    let postButton: UIButton = {
        let button = UIButton()
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    let imageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Image", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    var stack = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        stack.addArrangedSubview(getButton)
        stack.addArrangedSubview(postButton)
        stack.addArrangedSubview(imageButton)
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        stack.axis = .vertical
        stack.spacing = 30
        stack.backgroundColor = .clear
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        getButton.addTarget(self, action: #selector(tupGetButton), for: .touchUpInside)
        postButton.addTarget(self, action: #selector(tupPostButton), for: .touchUpInside)
        imageButton.addTarget(self, action: #selector(tupImageButton), for: .touchUpInside)
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            stack.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    @objc func tupGetButton() {
        let get = networkManager.getNetworkDataFetcher()
        get?.getDataForSearch(serachTerm: nil) { searchResults in
            guard let fetchPhotos = searchResults as? [TestModelTable] else { return }
            
           print(fetchPhotos)
        }
    }
    
    @objc func tupImageButton() {
        let vc = DownloadImageViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func tupPostButton() {
        let post = networkManager.postNetworkDataFetcher()
        post?.postData(complition: { json in
            guard let fetchPhotos = json else { return }
            print(fetchPhotos)
        })
        
    }
    
    
    
}
