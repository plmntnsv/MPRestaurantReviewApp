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
    
    func addRestaurant(name: String) async -> Result<Void, Error> {
        switch await service.addRestaurant(name) {
        case .success:
            return .success(())
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
        // TODO: notif
        coordinator.didFinishAddRestaurant()
    }
    
    func didAddRestaurant() {
        coordinator.didFinishAddRestaurant()
    }
}
