//
//  RestaurantsViewModel.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 31.05.25.
//

import Foundation

final class RestaurantsViewModel {
    let service: RestaurantsService
    let coordinator: RestaurantsCoordinator
    
    init(service: RestaurantsService, coordinator: RestaurantsCoordinator) {
        self.service = service
        self.coordinator = coordinator
    }
}
