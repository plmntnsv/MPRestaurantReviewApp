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
    
    func getNextRestaurants() async -> Result<[Restaurant], Error> {
        switch await service.getAllRestaurants(startAfterDoc: lastRestaurantsDoc) {
        case .success(let restaurantsResult):
            restaurants = restaurantsResult.restaurants
            lastRestaurantsDoc = restaurantsResult.lastDocument
            return .success(restaurants)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func didSelectRestaurant(at index: Int) {
        coordinator.showDetails(for: restaurants[index])
    }
}
