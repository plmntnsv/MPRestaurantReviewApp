//
//  RestaurantsViewModel.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 31.05.25.
//

import Foundation
import FirebaseFirestore

final class RestaurantsViewModel {
    private let service: RestaurantsService
    private let coordinator: RestaurantsCoordinator
    private(set) var restaurants: [Restaurant] = []
    private var lastRestaurantsDoc: DocumentSnapshot?
    
    init(service: RestaurantsService, coordinator: RestaurantsCoordinator) {
        self.service = service
        self.coordinator = coordinator
    }
    
    func getNextRestaurants(limit: Int = 10) async -> Result<[Restaurant], Error> {
        switch await service.getAllRestaurants(limit: limit, startAfterDoc: lastRestaurantsDoc) {
        case .success(let restaurantsResult):
            restaurants = restaurantsResult.restaurants
            lastRestaurantsDoc = restaurantsResult.lastDocument
            return .success(restaurants)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func refreshRestaurantsIfNeeded() async -> Bool {
        guard service.hasPendingUpdates else {
            return false
        }
        
        lastRestaurantsDoc = nil
        switch await getNextRestaurants(limit: restaurants.count) {
        case .success:
            service.hasPendingUpdates = false
            return true
        case .failure:
            return false
        }
    }
    
    func didSelectRestaurant(at index: Int) {
        coordinator.showDetails(for: restaurants[index])
    }
    
    func didTapAddButton() {
        coordinator.showAddRestaurant()
    }
}
