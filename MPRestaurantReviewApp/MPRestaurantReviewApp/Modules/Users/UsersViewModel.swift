//
//  UsersViewModel.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 31.05.25.
//

import Foundation

final class UsersViewModel {
    let service: UsersService
    let coordinator: UsersCoordinator
    
    init(service: UsersService, coordinator: UsersCoordinator) {
        self.service = service
        self.coordinator = coordinator
    }
}
