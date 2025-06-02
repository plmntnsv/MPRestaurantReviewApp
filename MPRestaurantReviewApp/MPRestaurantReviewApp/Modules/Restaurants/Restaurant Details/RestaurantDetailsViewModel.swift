//
//  RestaurantDetailsViewModel.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 1.06.25.
//

import Foundation

final class RestaurantDetailsViewModel {
    private let service: RestaurantsService
    private let coordinator: RestaurantsCoordinator
    private(set) var restaurant: Restaurant
    
    init(
        restaurant: Restaurant,
        service: RestaurantsService,
        coordinator: RestaurantsCoordinator
    ) {
        self.restaurant = restaurant
        self.service = service
        self.coordinator = coordinator
    }
    
    func didTapAddReview() {
        coordinator.showAddReview(for: restaurant)
    }
    
    func didTapSeeAllReviews() {
        coordinator.showAllReviews(for: restaurant)
    }
}
