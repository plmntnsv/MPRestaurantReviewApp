//
//  UsersService.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 1.06.25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

final class UsersService {
    func searchForUser(with email: String) async -> Result<[User], Error> {
        let db = Firestore.firestore()
        let query = db.collection(DataFieldKeyName.users).whereField(DataFieldKeyName.email, isEqualTo: email)
        
        do {
            let snapshot = try await query.getDocuments()
            let users = try snapshot.documents.compactMap { doc -> User? in
                try doc.data(as: User.self)
            }
            return .success(users)
        } catch {
            return .failure(error)
        }
    }
    
    func makeUserAdmin(with id: String) async -> Result<Void, Error> {
        do {
            let db = Firestore.firestore()
            try await db.collection(DataFieldKeyName.users).document(id).updateData([
                "isAdmin": true
            ])
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func deleteUser(with id: String) async -> Result<Void, Error> {
        do {
            // Only possible to delete a user from Firestore.
            // Firebase Auth doesn't permit user deletion through the clients.
            let db = Firestore.firestore()
            try await db.collection(DataFieldKeyName.users).document(id).delete()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
