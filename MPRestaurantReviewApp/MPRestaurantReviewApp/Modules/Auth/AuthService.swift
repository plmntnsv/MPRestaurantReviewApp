//
//  AuthService.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 30.05.25.
//

import Foundation
import Firebase
import FirebaseAuth

final class AuthService {
    private let usersRef = Firestore.firestore().collection("users")
    
    func loginUser(email: String, password: String) async -> Result<User, Error> {
        // first sing-in
        let singInResult: Result<FirebaseAuth.User, Error> = await withCheckedContinuation { continuation in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    continuation.resume(returning: .failure(error))
                    return
                }
                
                if let user = authResult?.user {
                    continuation.resume(returning: .success(user))
                } else {
                    continuation.resume(
                        returning: .failure(AppError.userNotFound.error)
                    )
                }
            }
        }
        
        switch singInResult {
        case .success(let fbUser):
            // sing-in successful - fetch user data
            switch await getUserData(id: fbUser.uid) {
            case .success(let user):
                return .success(user)
            case .failure(let error):
                return .failure(error)
            }
        case .failure(let error):
            // sing-in failure
            return .failure(error)
        }
    }
    
    func createUser(email: String, password: String, firstName: String, lastName: String) async -> Result<Void, Error> {
        return await withCheckedContinuation { continuation in
            Auth.auth().createUser(
                withEmail: email,
                password: password
            ) { [weak self] authResult, error in
                do {
                    let newUser = User(
                        email: email,
                        firstName: firstName,
                        lastName: lastName,
                        isAdmin: false
                    )
                    
                    guard let authResult else {
                        let error = error ?? AppError.userNotFound.error
                        continuation.resume(returning: .failure(error))
                        return
                    }
                    
                    try self?.usersRef.document(authResult.user.uid).setData(from: newUser)
                    
                    return continuation.resume(returning: .success(()))
                } catch {
                    return continuation.resume(returning: .failure(error))
                }
            }
        }
        
    }
    
    func getUserData(id: String) async -> Result<User, Error> {
        do {
            let user = try await usersRef.document(id).getDocument(as: User.self)
            
            return .success(user)
        } catch {
            print("Error decoding user: \(error)")
            return .failure(error)
        }
    }
}
