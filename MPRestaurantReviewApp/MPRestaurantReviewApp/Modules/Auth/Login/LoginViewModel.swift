//
//  LoginViewModel.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 28.05.25.
//

import Foundation

final class LoginViewModel {
    private weak var coordinator: AuthCoordinator!
    private let service: AuthService
    
    init(coordinator: AuthCoordinator, service: AuthService) {
        self.coordinator = coordinator
        self.service = service
    }
    
    func loginUser(email: String, password: String) async -> Result<Void, Error> {
        guard !email.isEmpty && !password.isEmpty else {
            return .failure(AppError.badInput(additionalInfo: "Email or password cannot be empty").error)
        }
        
        switch await service.loginUser(email: email, password: password) {
        case .success(let user):
            // TODO: Save user in UserRepo
            print("Successfully logged in: \(user)")
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func showRegistration() {
        coordinator.showRegistration()
    }
}
