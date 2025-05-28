//
//  LoginViewModel.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 28.05.25.
//

import Foundation

final class LoginViewModel {
    var username: String = ""
    var password: String = ""
    
    func login() async throws {
        guard !username.isEmpty, !password.isEmpty else {
            return
        }
        
        try? await LoginManager().login()
    }
}
