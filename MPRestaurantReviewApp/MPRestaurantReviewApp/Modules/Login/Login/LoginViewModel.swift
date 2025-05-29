//
//  LoginViewModel.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 28.05.25.
//

import Foundation

final class LoginViewModel {
    private weak var coordinator: LoginCoordinator!
    
    init(coordinator: LoginCoordinator) {
        self.coordinator = coordinator
    }
    
    func login(username: String, password: String) {
        guard !username.isEmpty && !password.isEmpty else {
            return
        }
    }
    
    func register() {
        coordinator.showRegistration()
    }
}
