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
        // TODO: Move these outside the coordinator
        // Restaurants tab
        let restaurantsNav = BaseNavigationController(
            tabBarImage: "building.2",
            selectedTabBarImage: "building.2.fill"
        )
        let restaurantsCoordinator = RestaurantsCoordinator(navigationController: restaurantsNav)
        addChildCoordinator(restaurantsCoordinator)
        restaurantsCoordinator.start()
        
        // Users tab
        let usersNav = BaseNavigationController(
            tabBarImage: "person.2",
            selectedTabBarImage: "person.2.fill"
        )
        let usersCoordinator = UsersCoordinator(navigationController: usersNav)
        addChildCoordinator(usersCoordinator)
        usersCoordinator.start()
        
        return [restaurantsNav, usersNav]
    }
}
