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
    
    func didAddRestaurant() {
        coordinator.didFinishAddRestaurant()
    }
}
