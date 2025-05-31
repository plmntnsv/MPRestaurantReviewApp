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
    
    func start() {
        startLoginFlow()
    }
    
    func removeAllViewControllers() {
        navigationController.setViewControllers([], animated: false)
    }
}

// MARK: - Coordinator Navigation
extension AppCoordinator {
    private func startLoginFlow() {
        let coordinator = AuthCoordinator(navigationController: navigationController)
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    func startMainFlow() {
        removeAllChildCoordinators()
        removeAllViewControllers()
        
        let tabCoordinator = TabBarCoordinator()
        addChildCoordinator(tabCoordinator)
        
        tabCoordinator.start()
    }
}
