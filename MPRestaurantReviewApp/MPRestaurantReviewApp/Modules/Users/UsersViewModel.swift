//
//  UsersViewModel.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 31.05.25.
//

import Foundation
import FirebaseAuth

final class UsersViewModel {
    private let service: UsersService
    private let coordinator: UsersCoordinator
    private(set) var searchResult: [User] = []
    private(set) var allUsers: [User] = []
    
    init(service: UsersService, coordinator: UsersCoordinator) {
        self.service = service
        self.coordinator = coordinator
    }
    
    func searchForUser(with email: String) async -> Result<Bool, Error> {
        switch await service.searchForUser(with: email.lowercased()) {
        case .success(let users):
            searchResult = users
            return .success(!users.isEmpty)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func clearSearchResult() {
        searchResult = []
    }
    
    func getAllUsers() async -> Result<Void, Error> {
        switch await service.getAllUsers() {
        case .success(let users):
            self.allUsers = users
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func deleteUser(_ user: User) async -> Result<Void, Error> {
        guard !user.isAdmin else {
            return .failure(AppError.badInput(additionalInfo: "You cannot delete Admin users").error)
        }
        
        guard user.id! != UserManager.shared.currentUser!.id else {
            return .failure(AppError.badInput(additionalInfo: "You cannot delete yourself").error)
        }
        
        switch await service.deleteUser(with: user.id!) {
        case .success:
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func makeUserAdmin(_ user: User) async -> Result<Void, Error> {
        guard !user.isAdmin else {
            return .failure(AppError.badInput(additionalInfo: "User already is an admin").error)
        }
        
        switch await service.makeUserAdmin(with: user.id!) {
        case .success:
            if let index = searchResult.firstIndex(where: { $0.id == user.id!}) {
                let old = searchResult[index]
                let new = User(
                    email: old.email,
                    firstName: old.firstName,
                    lastName: old.lastName,
                    role: UserRole.admin.rawValue
                )
                searchResult[index] = new
            }
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
}
