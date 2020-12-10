//
//  TabBarControllerAssembly.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import UIKit

enum TabBarControllerAssembly {
    static func createTabBarController() -> UITabBarController {

        let tabBar = UITabBarController()

        let mapViewController = MapVCAssembly.createMapVC()
        let mapNavigationController = MainNavigationControllerAssembly.createNavigationController(rootViewController: mapViewController)
        let mapTab = mapNavigationController
        let mapTabItem = UITabBarItem(title: "Заведения на карте",
                                      image: UIImage(systemName: "map"),
                                      selectedImage: UIImage(systemName: "map.fill"))
        mapTab.tabBarItem = mapTabItem


        let mainViewController = MainVCAssembly.createMainVC()
        let mainNavigationController = MainNavigationControllerAssembly.createNavigationController(rootViewController: mainViewController)
        let mainTab = mainNavigationController
        let mainTabItem = UITabBarItem(title: "Главная",
                                       image: UIImage(systemName: "list.bullet"),
                                       selectedImage: UIImage(systemName: "list.bullet"))
        mainTab.tabBarItem = mainTabItem


        let profileViewController = ProfileVCAssembly.createProfileVC()
        let profileNavigationController = MainNavigationControllerAssembly.createNavigationController(rootViewController: profileViewController)
        let profileTab = profileNavigationController
        let profileTabItem = UITabBarItem(title: "Профиль",
                                          image: UIImage(systemName: "person"),
                                          selectedImage: UIImage(systemName: "person.fill"))
        profileTab.tabBarItem = profileTabItem


        let basketViewController = BasketVCAssembly.createVC()
        let basketNavigationController = MainNavigationControllerAssembly.createNavigationController(rootViewController: basketViewController)
        let basketTab = basketNavigationController
        let basketTabItem = UITabBarItem(title: "Корзина",
                                         image: UIImage(systemName: "bag"),
                                         selectedImage: UIImage(systemName: "bag.fill"))
        basketTab.tabBarItem = basketTabItem

        let controllers = [mainTab, mapTab, basketTab, profileTab]
        tabBar.viewControllers = controllers

        return tabBar
    }
}

