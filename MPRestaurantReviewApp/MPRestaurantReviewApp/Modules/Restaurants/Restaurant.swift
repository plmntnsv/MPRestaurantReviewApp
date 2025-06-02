//
//  Restaurant.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 1.06.25.
//

import Foundation
import FirebaseFirestore

struct Restaurant: Codable, Identifiable {
    var id: String?
    var name: String
    var avgRating: Double
    var highestReview: Review?
    var lowestReview: Review?
    var latestReview: Review?
}
