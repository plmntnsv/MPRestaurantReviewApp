//
//  Restaurant.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 1.06.25.
//

import Foundation
import FirebaseFirestore

struct Restaurant: Codable, Identifiable, Equatable {
    @DocumentID var id: String?
    var name: String
    var averageRating: Double
    var ratingsCount: Int
    var highestReviewId: String?
    var lowestReviewId: String?
    var latestReviewId: String?
}
