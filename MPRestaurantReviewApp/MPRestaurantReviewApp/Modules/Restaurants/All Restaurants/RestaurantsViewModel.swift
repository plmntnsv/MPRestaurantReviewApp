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
    private(set) var pagingIsComplete = false
    
    init(service: RestaurantsService, coordinator: RestaurantsCoordinator) {
        self.service = service
        self.coordinator = coordinator
    }
    
    func getNextRestaurants(
        shouldRefresh: Bool = false,
        limit: Int = 10
    ) async -> Result<[Restaurant], Error> {
        if shouldRefresh {
            lastRestaurantsDoc = nil
            restaurants = []
        }
        
        switch await service.getAllRestaurants(limit: limit, startAfterDoc: lastRestaurantsDoc) {
        case .success(let restaurantsResult):
            if restaurantsResult.restaurants.isEmpty {
                pagingIsComplete = true
            } else {
                restaurants.append(contentsOf: restaurantsResult.restaurants)
            }
            
            lastRestaurantsDoc = restaurantsResult.lastDocument
            return .success(restaurants)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func deleteRestaurant(_ restaurant: Restaurant) async -> Result<Void, Error> {
        switch await service.deleteRestaurant(restaurant) {
        case .success:
            if let indexToRemove = restaurants.firstIndex(of: restaurant) {
                restaurants.remove(at: indexToRemove)
            }
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func editRestaurant(_ restaurant: Restaurant) {
        if let indexToRemove = restaurants.firstIndex(where: { $0.id == restaurant.id }) {
            restaurants.remove(at: indexToRemove)
            restaurants.insert(restaurant, at: indexToRemove)
        }
    }
    
    func showRestaurantDetails(at index: Int) {
        coordinator.showDetails(for: restaurants[index])
    }
    
    func showAddRestaurant() {
        coordinator.showAddRestaurant(screenType: .add)
    }
    
    func goToEditRestaurant(_ restaurant: Restaurant) {
        coordinator.showAddRestaurant(screenType: .edit(restaurant))
    }
}
