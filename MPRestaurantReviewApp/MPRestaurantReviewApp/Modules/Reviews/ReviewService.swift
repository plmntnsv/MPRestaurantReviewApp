//
//  ReviewService.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 2.06.25.
//

import Foundation
import FirebaseFirestore

final class ReviewService {
    private let db = Firestore.firestore()
    
    func getAllReviews(
        for restaurantId: String,
        startAfterDoc: DocumentSnapshot? = nil,
        limit: Int = 10
    ) async -> Result<ReviewsSuccessDataResult, Error> {
        var reviewsQuery = db.collection("reviews").limit(to: limit)
        
        if let lastDoc = startAfterDoc {
            reviewsQuery = reviewsQuery.start(afterDocument: lastDoc)
        }
        
        do {
            let snapshot = try await reviewsQuery.getDocuments()
            var reviews: [Review] = snapshot.documents.compactMap {
                try? $0.data(as: Review.self)
            }
            
            return .success(
                ReviewsSuccessDataResult(
                    reviews: reviews,
                    lastDocument: snapshot.documents.last)
            )
        } catch {
            return .failure(error)
        }
    }
    
    func addReview(
        restaurantId: String,
        userId: String,
        comment: String,
        author: String,
        rating: Double,
        visited: String
    ) {
        
    }
}
