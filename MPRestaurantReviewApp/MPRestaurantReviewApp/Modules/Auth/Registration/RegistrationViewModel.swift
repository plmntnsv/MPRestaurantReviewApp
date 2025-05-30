//
//  RegistrationViewModel.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 30.05.25.
//

import Foundation

final class RegistrationViewModel {
    private weak var coordinator: AuthCoordinator!
    
    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
    }
    
    func didTapSignUp() {
        
    }
    
    private func finishRegistration() {
        coordinator.didFinishLogin()
    }
}
