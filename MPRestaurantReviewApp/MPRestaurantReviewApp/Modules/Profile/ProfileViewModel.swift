//
//  ProfileViewModel.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 31.05.25.
//

import Foundation

final class ProfileViewModel {
    private let service: ProfileService
    private let coordinator: ProfileCoordinator
    
    init(service: ProfileService, coordinator: ProfileCoordinator) {
        self.service = service
        self.coordinator = coordinator
    }
}
