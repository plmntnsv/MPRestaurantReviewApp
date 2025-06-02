//
//  RestaurantsCoordinator.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 1.06.25.
//

import Foundation
import UIKit

final class RestaurantsCoordinator: Coordinator {
    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        showRestaurantsScreen()
    }
    
    private func showRestaurantsScreen() {
        let service = RestaurantsService()
        let viewModel = RestaurantsViewModel(service: service, coordinator: self)
        let viewController = RestaurantsViewController()
        viewController.viewModel = viewModel
        
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func showDetails(for restaurant: Restaurant) {
        let service = RestaurantsService()
        let viewModel = RestaurantDetailsViewModel(restaurant: restaurant, service: service, coordinator: self)
        let viewController = RestaurantDetailsViewController()
        viewController.viewModel = viewModel
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showAddReview(for restaurant: Restaurant) {
        let service = ReviewService()
    }
}
