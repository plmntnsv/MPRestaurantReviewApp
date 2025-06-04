//
//  TabBarCoordinator.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 30.05.25.
//

import Foundation
import UIKit

class TabBarCoordinator: Coordinator {
    private let tabBarController: BaseTabBarController
    private let window: UIWindow
    
    init(in window: UIWindow) {
        self.window = window
        tabBarController = BaseTabBarController()
        super.init()
        initializeTabs().forEach { self.tabBarController.addChild($0) }
    }
    
    override func start() {
        window.rootViewController = tabBarController
    }
    
    private func initializeTabs() -> [UIViewController] {
        var tabs: [UIViewController] = []
        // Restaurants tab
        let restaurantsNav = BaseNavigationController(
            tabBarImage: "building.2",
            selectedTabBarImage: "building.2.fill"
        )
        let restaurantsCoordinator = RestaurantsCoordinator(navigationController: restaurantsNav)
        addChildCoordinator(restaurantsCoordinator)
        restaurantsCoordinator.start()
        tabs.append(restaurantsNav)
        
        // Users tab
        if UserManager.shared.currentUser!.isAdmin {
            let usersNav = BaseNavigationController(
                tabBarImage: "person.2",
                selectedTabBarImage: "person.2.fill"
            )
            let usersCoordinator = UsersCoordinator(navigationController: usersNav)
            addChildCoordinator(usersCoordinator)
            usersCoordinator.start()
            tabs.append(usersNav)
        }
        
        // Profile tab
        let profileNav = BaseNavigationController(
            tabBarImage: "person.crop.circle",
            selectedTabBarImage: "person.crop.circle.fill"
        )
        let profileCoordinator = ProfileCoordinator(navigationController: profileNav)
        addChildCoordinator(profileCoordinator)
        profileCoordinator.start()
        tabs.append(profileNav)
        
        return tabs
    }
}
