//
//  ProfileViewModel.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 31.05.25.
//

import Foundation
import FirebaseAuth

final class ProfileViewModel {
    private let service: ProfileService
    private let coordinator: ProfileCoordinator
    let currentUser = UserManager.shared.currentUser
    
    init(service: ProfileService, coordinator: ProfileCoordinator) {
        self.service = service
        self.coordinator = coordinator
    }
    
    func logout() -> Result<Void, Error> {
        do {
            try Auth.auth().signOut()
            UserManager.shared.removeCurrentUser()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func userDidLogout() {
        coordinator.userDidLogout()
    }
}
