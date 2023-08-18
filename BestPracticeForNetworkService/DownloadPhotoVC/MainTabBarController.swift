//
//  MainTabBarController.swift
//  TestNetworking
//
//  Created by Kirill on 29.07.2023.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        let networkBuilder = PhotoNetworkBulder()
        
        let photosVC = PhotosCollectionViewController()
        //photosVC.networkDataFetcher = networkBuilder.PhotoNetworkDataFetcher()
        let library = LibraryViewController()
        
        if #available(iOS 13, *) {
            let aperance = UITabBarAppearance()
            aperance.backgroundColor = .white
            aperance.shadowColor = .clear
            self.tabBar.standardAppearance = aperance
        }
        
        viewControllers = [generateNavigationController(rootVC: photosVC, title: "Photos", image: "photo.on.rectangle"), generateNavigationController(rootVC: library, title: "Favourites", image: "heart.rectangle.fill")]
    }
    
    private func generateNavigationController(rootVC: UIViewController, title: String, image: String) -> UIViewController {
        let navigation = UINavigationController(rootViewController: rootVC)
        navigation.tabBarItem.title = title
        navigation.tabBarItem.image = UIImage(systemName: image)
        tabBar.tintColor = .cyan
        tabBar.unselectedItemTintColor = .gray
        return navigation
    }
}
