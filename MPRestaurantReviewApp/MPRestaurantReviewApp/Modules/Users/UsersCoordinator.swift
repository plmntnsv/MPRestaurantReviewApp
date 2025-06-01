//
//  UsersCoordinator.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 1.06.25.
//

import Foundation
import UIKit

final class UsersCoordinator: Coordinator {
    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let service = UsersService()
        let viewModel = UsersViewModel(service: service, coordinator: self)
        let viewController = UsersViewController()
        viewController.viewModel = viewModel
        
        navigationController.pushViewController(viewController, animated: false)
    }
}
