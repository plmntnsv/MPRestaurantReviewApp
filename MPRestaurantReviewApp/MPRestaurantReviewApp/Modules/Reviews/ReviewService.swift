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
        let restaurantRef = db.collection("restaurants").document(restaurantId)
        var reviewsQuery = restaurantRef.collection("reviews").limit(to: limit)
        
        if let lastDoc = startAfterDoc {
            reviewsQuery = reviewsQuery.start(afterDocument: lastDoc)
        }
        
        do {
            let snapshot = try await reviewsQuery.getDocuments()
            let reviews: [Review] = snapshot.documents.compactMap {
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
    
    func addReviewToRestaurant(_ review: Review, to restaurant: Restaurant) async -> Result<Void, Error> {
        let restaurantRef = db.collection("restaurants").document(restaurant.id!)
        let reviewsCollection = restaurantRef.collection("reviews")
        let newReviewRef = reviewsCollection.document()
        
        do {
            let _ = try await db.runTransaction { transaction, errorPointer -> Any? in
                do {
                    // Get the restaurant snapshot
                    guard let restaurantDoc = try? transaction.getDocument(restaurantRef) else {
                        errorPointer?.pointee = AppError.decodingError.error
                        return nil
                    }
                    
                    guard var restaurant = try? restaurantDoc.data(as: Restaurant.self) else {
                        errorPointer?.pointee = AppError.decodingError.error
                        return nil
                    }
                    
                    // Save new review
                    let reviewToSave = review
                    try transaction.setData(from: reviewToSave, forDocument: newReviewRef)

                    
                    // Update latest review
                    restaurant.latestReview = reviewToSave
                    
                    // Check if hiher and update
                    if restaurant.highestReview == nil || review.rating >= restaurant.highestReview!.rating {
                        restaurant.highestReview = reviewToSave
                    }
                    
                    // Check if lower and update
                    if restaurant.lowestReview == nil || review.rating <= restaurant.lowestReview!.rating {
                        restaurant.lowestReview = reviewToSave
                    }
                    
                    // Update average rating
                    let totalRating = restaurant.averageRating * Double(restaurant.ratingsCount)
                    restaurant.ratingsCount += 1
                    restaurant.averageRating = (totalRating + review.rating) / Double(restaurant.ratingsCount)
                    
                    // Finally save the restaurant
                    try transaction.setData(from: restaurant, forDocument: restaurantRef)
                    
                    return nil
                    
                } catch {
                    errorPointer?.pointee = error as NSError
                    return nil
                }
                
            }
            
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
