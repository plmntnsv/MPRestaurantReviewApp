//
//  AddReviewViewModel.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 2.06.25.
//

import Foundation
import Firebase

final class AddReviewViewModel {
    private let service: ReviewService
    private let coordinator: RestaurantsCoordinator
    private(set) var restaurant: Restaurant
    
    init(
        restaurant: Restaurant,
        service: ReviewService,
        coordinator: RestaurantsCoordinator
    ) {
        self.restaurant = restaurant
        self.service = service
        self.coordinator = coordinator
    }
    
    func didTapAdd(rating: Double, comment: String, visitDate: Date) async -> Result<Review, Error> {
        let currentUser = UserManager.shared.currentUser!
        let review = Review(
            restaurantId: restaurant.id!,
            userId: currentUser.id!,
            author: "\(currentUser.firstName) \(currentUser.lastName)",
            rating: rating,
            comment: comment,
            visitDate: visitDate,
            createdAt: Date.now
        )
        
        switch await service.addReviewToRestaurant(review, to: restaurant) {
        case .success:
            return .success(review)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func finishAddingReview() {
        coordinator.didFinishAddReview()
    }
}
