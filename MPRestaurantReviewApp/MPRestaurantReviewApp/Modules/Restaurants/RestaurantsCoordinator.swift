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
    private var needsDataUpdate: Bool = false
    private let restaurantService = RestaurantsService()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        showRestaurantsScreen()
    }
    
    private func showRestaurantsScreen() {
        let viewModel = RestaurantsViewModel(service: restaurantService, coordinator: self)
        let viewController = RestaurantsViewController()
        viewController.viewModel = viewModel
        
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func showDetails(for restaurant: Restaurant) {
        let viewModel = RestaurantDetailsViewModel(restaurant: restaurant, service: restaurantService, coordinator: self)
        let viewController = RestaurantDetailsViewController()
        viewController.viewModel = viewModel
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showAddReview(for restaurant: Restaurant) {
        let service = ReviewService()
        let viewModel = AddReviewViewModel(restaurant: restaurant, service: service, coordinator: self)
        let viewController = AddReviewViewController()
        viewController.viewModel = viewModel
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func didFinishAddReview() {
        restaurantService.hasPendingUpdates = true
        navigationController.popViewController(animated: true)
    }
    
    func showAllReviews(for restaurant: Restaurant) {
        let service = ReviewService()
        let viewModel = AllReviewsViewModel(restaurant: restaurant, service: service, coordinator: self)
        let viewController = AllReviewsViewController()
        viewController.viewModel = viewModel
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showAddRestaurant() {
        let viewModel = AddRestaurantViewModel(service: restaurantService, coordinator: self)
        let viewController = AddRestaurantViewController()
        viewController.viewModel = viewModel
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func didFinishAddRestaurant() {
        restaurantService.hasPendingUpdates = true
        navigationController.popViewController(animated: true)
    }
}
