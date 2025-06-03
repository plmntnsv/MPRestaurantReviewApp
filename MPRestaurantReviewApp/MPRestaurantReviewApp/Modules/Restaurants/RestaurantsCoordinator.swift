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
    
    private var restaurantsViewController: RestaurantsViewController?
    private var restaurantDetailsViewController: RestaurantDetailsViewController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        showRestaurants()
    }
    
    private func showRestaurants() {
        let viewModel = RestaurantsViewModel(service: restaurantService, coordinator: self)
        let viewController = RestaurantsViewController()
        viewController.viewModel = viewModel
        restaurantsViewController = viewController
        
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func showDetails(for restaurant: Restaurant) {
        let viewModel = RestaurantDetailsViewModel(restaurant: restaurant, service: restaurantService, coordinator: self)
        let viewController = RestaurantDetailsViewController()
        viewController.viewModel = viewModel
        restaurantDetailsViewController = viewController
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showAddReview(for restaurant: Restaurant) {
        let service = ReviewService()
        let viewModel = AddReviewViewModel(restaurant: restaurant, service: service, coordinator: self)
        let viewController = AddReviewViewController()
        viewController.viewModel = viewModel
        viewController.delegate = restaurantDetailsViewController
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func didFinishAddReview() {
        navigationController.popViewController(animated: true)
    }
    
    func showAllReviews(for restaurant: Restaurant) {
        let service = ReviewService()
        let viewModel = AllReviewsViewModel(restaurant: restaurant, service: service, coordinator: self)
        let viewController = AllReviewsViewController()
        viewController.viewModel = viewModel
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showAddRestaurant(screenType: AddRestaurantViewController.ScreenType) {
        let viewModel = AddRestaurantViewModel(service: restaurantService, coordinator: self)
        let viewController = AddRestaurantViewController()
        viewController.screenType = screenType
        viewController.viewModel = viewModel
        viewController.delegate = restaurantsViewController
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func didFinishAddRestaurant() {
        navigationController.popViewController(animated: true)
    }
}
