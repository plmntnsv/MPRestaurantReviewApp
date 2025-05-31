//
//  RegistrationViewModel.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 30.05.25.
//

import Foundation
import FirebaseAuth

final class RegistrationViewModel {
    private weak var coordinator: AuthCoordinator!
    private let service: AuthService
    
    init(coordinator: AuthCoordinator, service: AuthService) {
        self.coordinator = coordinator
        self.service = service
    }
    
    func registerUser(
        email: String,
        password: String,
        firstName: String,
        lastName: String
    ) async -> Result<Void, Error> {
        let userResult = await service.createUser(
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName
        )
        
        switch userResult {
        case .success:
            let loggedInResult = await service.loginUser(email: email, password: password)
            
            switch loggedInResult {
            case .success(let user):
                UserManager.shared.saveUser(user)
                return .success(())
            case .failure(let error):
                return .failure(error)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
    
    private func finishRegistration() {
        coordinator.didFinishLogin()
    }
}
