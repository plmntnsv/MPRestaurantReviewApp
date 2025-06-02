//
//  AppCoordinator.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 29.05.25.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var window: UIWindow
    
    init(navigationController: UINavigationController, window: UIWindow) {
        self.navigationController = navigationController
        self.window = window
    }
    
    override func start() {
        startLoginFlow()
    }
    
    func removeAllViewControllers() {
        navigationController.setViewControllers([], animated: false)
    }
}

// MARK: - Coordinator Navigation
extension AppCoordinator {
    func startLoginFlow() {
        removeAllChildCoordinators()
        removeAllViewControllers()
        
        let coordinator = AuthCoordinator(navigationController: navigationController, in: window)
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    func startMainFlow() {
        removeAllChildCoordinators()
        removeAllViewControllers()
        
        let tabCoordinator = TabBarCoordinator(in: window)
        addChildCoordinator(tabCoordinator)
        
        tabCoordinator.start()
    }
}
