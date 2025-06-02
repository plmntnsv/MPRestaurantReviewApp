//
//  Review.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 1.06.25.
//

import Foundation
import FirebaseFirestore

struct Review: Codable, Identifiable {
    @DocumentID var id: String?
    var restaurantId: String
    var userId: String
    var author: String
    var rating: Double
    var comment: String
    var visitDate: Date
    var createdAt: Date
}
