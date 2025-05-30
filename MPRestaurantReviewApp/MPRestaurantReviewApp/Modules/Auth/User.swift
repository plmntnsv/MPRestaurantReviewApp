//
//  User.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 30.05.25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct User: Codable, Identifiable {
    @DocumentID var id: String?
    let email: String
    let firstName: String
    let lastName: String
    let isAdmin: Bool
}
