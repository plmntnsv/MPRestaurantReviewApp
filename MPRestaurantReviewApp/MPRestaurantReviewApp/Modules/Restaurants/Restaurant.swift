//
//  Restaurant.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 1.06.25.
//

import Foundation
import FirebaseFirestore

struct Restaurant: Codable, Identifiable, Equatable {
    var id: String?
    var name: String
    var averageRating: Double
    var ratingsCount: Int
    var highestReview: Review?
    var lowestReview: Review?
    var latestReview: Review?
}
