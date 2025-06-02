//
//  ProfileCoordinator.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 1.06.25.
//

import Foundation
import UIKit

final class ProfileCoordinator: Coordinator {
    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let service = ProfileService()
        let viewModel = ProfileViewModel(service: service, coordinator: self)
        let viewController = ProfileViewController()
        viewController.viewModel = viewModel
        
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func userDidLogout() {
        DispatchQueue.main.async {
            self.appCoordinator.startLoginFlow()
        }
    }
}
