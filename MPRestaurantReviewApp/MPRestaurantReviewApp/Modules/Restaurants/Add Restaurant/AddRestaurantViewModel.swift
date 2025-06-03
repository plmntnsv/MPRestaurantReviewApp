//
//  AddRestaurantViewModel.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 1.06.25.
//

import Foundation

final class AddRestaurantViewModel {
    private let service: RestaurantsService
    private let coordinator: RestaurantsCoordinator
    
    init(service: RestaurantsService, coordinator: RestaurantsCoordinator) {
        self.service = service
        self.coordinator = coordinator
    }
    
    func addRestaurant(name: String) async -> Result<String, Error> {
        let newRestaurant = Restaurant(name: name, averageRating: 0, ratingsCount: 0)
        switch await service.addRestaurant(newRestaurant) {
        case .success(let id):
            return .success(id)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func editRestaurant(_ restaurant: Restaurant, newName: String) async -> Result<Restaurant, Error> {
        var newRestaurant = restaurant
        newRestaurant.name = newName
        switch await service.editRestaurant(newRestaurant) {
        case .success:
            return .success(newRestaurant)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func didEditRestaurant(_ restaurant: Restaurant) {
        coordinator.didFinishAddRestaurant()
    }
    
    func didAddRestaurant() {
        coordinator.didFinishAddRestaurant()
    }
}
