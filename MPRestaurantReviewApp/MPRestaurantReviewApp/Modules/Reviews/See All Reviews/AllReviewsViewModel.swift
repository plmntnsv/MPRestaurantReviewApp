//
//  AllReviewsViewModel.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 2.06.25.
//

import Foundation
import FirebaseFirestore

final class AllReviewsViewModel {
    private let service: ReviewService
    private let coordinator: RestaurantsCoordinator
    private(set) var reviews: [Review]
    private(set) var restaurant: Restaurant
    private var lastReviewsDoc: DocumentSnapshot?
    private(set) var pagingIsComplete = false
    
    init(
        restaurant: Restaurant,
        service: ReviewService,
        coordinator: RestaurantsCoordinator
    ) {
        self.restaurant = restaurant
        self.service = service
        self.coordinator = coordinator
        reviews = []
    }
    
    func fetchReviews() async -> Result<Void, Error> {
        switch await service.getReviews(for: restaurant.id!, startAfterDoc: lastReviewsDoc) {
        case .success(let result):
            if result.reviews.isEmpty {
                pagingIsComplete = true
            } else {
                reviews += result.reviews
            }
            lastReviewsDoc = result.lastDocument
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func updateExistingReview(with review: Review) -> Bool {
        if let index = reviews.firstIndex(where: { $0.id == review.id }) {
            reviews[index] = review
            return true
        }
        
        return false
    }
    
    func deleteReview(_ review: Review) async -> Result<Void, Error> {
        switch await service.deleteReview(restaurantId: restaurant.id!, reviewId: review.id!) {
        case .success:
            if let indexToRemove = reviews.firstIndex(where: { $0.id == review.id }) {
                reviews.remove(at: indexToRemove)
            }
            
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func showEditReview(_ review: Review) {
        coordinator.showAddReview(for: restaurant, screenType: .edit(review))
    }
}
