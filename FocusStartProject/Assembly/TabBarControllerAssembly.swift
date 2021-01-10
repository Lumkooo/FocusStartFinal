//
//  TabBarControllerAssembly.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import UIKit

enum TabBarControllerAssembly {
    static func createTabBarController() -> UITabBarController {
        
        // MARK: - Constants
        enum Images {
            static let mapTabImage = UIImage(systemName: "map")
            static let mapTabFilledImage = UIImage(systemName: "map.fill")
            static let mainTabImage = UIImage(systemName: "list.bullet")
            static let profileTabImage = UIImage(systemName: "person")
            static let profileTabFilledImage = UIImage(systemName: "person.fill")
            static let bagTabImage = UIImage(systemName: "bag")
            static let bagTabFilledImage = UIImage(systemName: "bag.fill")
        }
        
        let tabBar = UITabBarController()
        
        // MARK: - MapTab
        
        let mapViewController = MapVCAssembly.createVC()
        let mapNavigationController = MainNavigationControllerAssembly.createNavigationController(rootViewController: mapViewController)
        let mapTab = mapNavigationController
        let mapTabItem = UITabBarItem(title: "Заведения на карте",
                                      image: Images.mapTabImage,
                                      selectedImage: Images.mapTabFilledImage)
        mapTab.tabBarItem = mapTabItem
        
        // MARK: - MainTab
        
        let mainViewController = MainVCAssembly.createVC()
        let mainNavigationController = MainNavigationControllerAssembly.createNavigationController(rootViewController: mainViewController)
        let mainTab = mainNavigationController
        let mainTabItem = UITabBarItem(title: "Главная",
                                       image: Images.mainTabImage,
                                       selectedImage: Images.mainTabImage)
        mainTab.tabBarItem = mainTabItem
        
        // MARK: - ProfileTab
        
        let profileViewController = ProfileVCAssembly.createVC()
        let profileNavigationController = MainNavigationControllerAssembly.createNavigationController(rootViewController: profileViewController)
        let profileTab = profileNavigationController
        let profileTabItem = UITabBarItem(title: "Профиль",
                                          image: Images.profileTabImage,
                                          selectedImage: Images.profileTabFilledImage)
        profileTab.tabBarItem = profileTabItem
        
        // MARK: - BasketTab
        
        let basketViewController = BasketVCAssembly.createVC()
        let basketNavigationController = MainNavigationControllerAssembly.createNavigationController(rootViewController: basketViewController)
        let basketTab = basketNavigationController
        let basketTabItem = UITabBarItem(title: "Корзина",
                                         image: Images.bagTabImage,
                                         selectedImage: Images.bagTabFilledImage)
        basketTab.tabBarItem = basketTabItem
        
        let controllers = [mainTab, mapTab, basketTab, profileTab]
        tabBar.viewControllers = controllers
        
        return tabBar
    }
}

