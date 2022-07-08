//
//  MainTabBarViewController.swift
//  Food Application
//
//  Created by Admin on 07.07.2022.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func  generateTabBar() {
        self.viewControllers = [geberateVC(vc: UINavigationController(rootViewController: CathalogViewController()), title: "", image: UIImage(systemName: "book")!),
                                geberateVC(vc: UINavigationController(rootViewController: CartViewController()), title: "", image: UIImage(systemName: "cart")!),
                                geberateVC(vc: UINavigationController(rootViewController: ProfileViewController()), title: "", image: UIImage(systemName: "smiley.fill")!)]

    }
    func geberateVC(vc:UINavigationController,title:String,image:UIImage) -> UINavigationController {
        vc.tabBarItem.title = title
        vc.tabBarItem.image = image
        return vc
    }
}
