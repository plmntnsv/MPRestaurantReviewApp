//
//  UserManager.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 31.05.25.
//

import Foundation

enum UserRole: String {
    case admin
    case user
}

final class UserManager {
    static let shared = UserManager()
    private init() {}
    
    private(set) var currentUser: User?
    
    var currentUserRole: UserRole {
        guard let currentUser, let userRole = UserRole(rawValue: currentUser.role) else {
            // return lowest permission role
            return .user
        }
        
        return userRole
    }
    
    func saveUser(_ user: User) {
        currentUser = user
    }
    
    func removeCurrentUser() {
        currentUser = nil
    }
}
