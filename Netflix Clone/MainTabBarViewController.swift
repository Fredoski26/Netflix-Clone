//
//  ViewController.swift
//  Netflix Clone
//
//  Created by Fredrick on 28/08/2023.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .systemRed
        
        
        let vct1 = UINavigationController(rootViewController: HomeViewController())
        let vct2 = UINavigationController(rootViewController: UpComingViewController())
        let vct3 = UINavigationController(rootViewController: SearchViewController())
        let vct4 = UINavigationController(rootViewController: DownloadsViewController())
        
        vct1.tabBarItem.image = UIImage(systemName: "house")
        vct2.tabBarItem.image = UIImage(systemName: "play.circle")
        vct3.tabBarItem.image = UIImage(systemName:  "magnifyingglass")
        vct4.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        
        vct1.title = "Home"
        vct2.title = "Coming Soon"
        vct3.title = "Top Search"
        vct4.title = "Downloads"
        
        
        //tabBar.tintColor = .label

        setViewControllers([vct1, vct2, vct3, vct4], animated: true)
    }


}

