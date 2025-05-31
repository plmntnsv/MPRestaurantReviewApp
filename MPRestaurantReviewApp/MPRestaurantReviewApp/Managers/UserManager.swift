//
//  UserManager.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 31.05.25.
//

import Foundation

final class UserManager {
    static let shared = UserManager()
    private init() {}
    
    private(set) var currentUser: User?
    
    func saveUser(_ user: User) {
        currentUser = user
    }
    
    func removeCurrentUser() {
        currentUser = nil
    }
}
