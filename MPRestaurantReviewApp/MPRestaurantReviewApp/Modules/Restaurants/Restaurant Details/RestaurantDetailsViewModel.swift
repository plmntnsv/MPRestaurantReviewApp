//
//  RestaurantDetailsViewModel.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 1.06.25.
//

import Foundation

struct RestaurantDetailsKeyReviews {
    let latest: Review?
    let highest: Review?
    let lowest: Review?
}

final class RestaurantDetailsViewModel {
    private let service: RestaurantsService
    private let coordinator: RestaurantsCoordinator
    private(set) var restaurant: Restaurant
    private(set) var keyReviews: RestaurantDetailsKeyReviews?
    
    init(
        restaurant: Restaurant,
        service: RestaurantsService,
        coordinator: RestaurantsCoordinator
    ) {
        self.restaurant = restaurant
        self.service = service
        self.coordinator = coordinator
    }
    
    func showAddReview() {
        coordinator.showAddReview(for: restaurant, screenType: .add)
    }
    
    func showSeeAllReviews() {
        coordinator.showAllReviews(for: restaurant)
    }
    
    func getKeyReviews() async {
        self.keyReviews = await service.getRestaurantKeyReviews(restaurant)
    }
    
    func getRestaurant() async -> Result<Void, Error> {
        switch await service.getRestaurant(withId: restaurant.id!) {
        case .success(let restaurant):
            self.restaurant = restaurant
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
}
