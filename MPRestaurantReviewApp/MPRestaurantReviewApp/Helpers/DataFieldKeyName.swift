//
//  DataFieldKeyName.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 3.06.25.
//

import Foundation

enum DataFieldKeyName {
    // collection names
    static let reviews = "reviews"
    static let restaurants = "restaurants"
    
    // restaurants
    static let name = "name"
    static let averageRating = "averageRating"
    static let ratingsCount = "ratingsCount"
    static let highestReviewId = "highestReviewId"
    static let lowestReviewId = "lowestReviewId"
    static let latestReviewId = "latestReviewId"
    
    // reviews
    static let rating = "rating"
    static let createdAt = "createdAt"
    static let visitDate = "visitDate"
    static let reviewId = "reviewId"
    static let comment = "comment"
    static let userId = "userId"
    static let author = "author"
}
