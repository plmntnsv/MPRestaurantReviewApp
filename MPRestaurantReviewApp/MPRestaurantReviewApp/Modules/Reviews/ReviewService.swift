//
//  ReviewService.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 2.06.25.
//

import Foundation
import FirebaseFirestore

final class ReviewService {
    private let restaurantsDB = Firestore.firestore().collection(DataFieldKeyName.restaurants)
    
    func getReviews(
        for restaurantId: String,
        startAfterDoc: DocumentSnapshot? = nil,
        limit: Int = 10
    ) async -> Result<ReviewsSuccessDataResult, Error> {
        let restaurantRef = restaurantsDB.document(restaurantId)
        var reviewsQuery = restaurantRef.collection(DataFieldKeyName.reviews).limit(to: limit)
        
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
        let restaurantRef = restaurantsDB.document(restaurant.id!)
        let reviewsCollection = restaurantRef.collection(DataFieldKeyName.reviews)
        let reviewRef = reviewsCollection.document()
        let newReviewId = reviewRef.documentID
        
        do {
            let _ = try await Firestore.firestore().runTransaction { transaction, errorPointer in
                do {
                    try reviewRef.setData(from: review)
                    
                    guard let restaurantDoc = try? transaction.getDocument(restaurantRef) else {
                        errorPointer?.pointee = AppError.decodingError.error
                        return
                    }
                    
                    guard let restaurant = try? restaurantDoc.data(as: Restaurant.self) else {
                        errorPointer?.pointee = AppError.decodingError.error
                        return
                    }
                    
                    var updates: [String: Any] = [:]
                    
                    // Check and set highest review
                    if let highestId = restaurant.highestReviewId {
                        let highestRef = reviewsCollection.document(highestId)
                        
                        if let highestSnapshot = try? transaction.getDocument(highestRef),
                           let highestRating = highestSnapshot.get(DataFieldKeyName.rating) as? Double,
                           review.rating >= highestRating {
                            updates[DataFieldKeyName.highestReviewId] = newReviewId
                        }
                    } else {
                        updates[DataFieldKeyName.highestReviewId] = newReviewId
                    }
                    
                    // Check and set lowest review
                    if let lowestId = restaurant.lowestReviewId {
                        let lowestRef = reviewsCollection.document(lowestId)
                        
                        if let lowestSnapshot = try? transaction.getDocument(lowestRef),
                           let lowestRating = lowestSnapshot.get(DataFieldKeyName.rating) as? Double,
                           review.rating <= lowestRating {
                            updates[DataFieldKeyName.lowestReviewId] = newReviewId
                        }
                    } else {
                        updates[DataFieldKeyName.lowestReviewId] = newReviewId
                    }
                    
                    // Set latest review
                    updates[DataFieldKeyName.latestReviewId] = newReviewId
                    updates[DataFieldKeyName.name] = restaurant.name
                    
                    
                    // Set average rating & count
                    let ratingsCount = restaurant.ratingsCount + 1
                    updates[DataFieldKeyName.ratingsCount] = ratingsCount
                    let totalRating = restaurant.averageRating * Double(restaurant.ratingsCount)
                    updates[DataFieldKeyName.averageRating] = (totalRating + review.rating) / Double(ratingsCount)
                    
                    // Update
                    transaction.updateData(updates, forDocument: restaurantRef)
                    
                    return
                } catch {
                    errorPointer?.pointee = error as NSError
                    return
                }
            }
            
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func editReview(_ editedReview: Review, for restaurantId: String) async -> Result<Void, Error> {
        let restaurantRef = restaurantsDB.document(restaurantId)
        let reviewsRef = restaurantRef.collection(DataFieldKeyName.reviews)
        let reviewRef = reviewsRef.document(editedReview.id!)
        
        do {
            try reviewRef.setData(from: editedReview)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func deleteReview(restaurantId: String, reviewId: String) async -> Result<Void, Error> {
        let reviewRef = restaurantsDB.document(restaurantId).collection(DataFieldKeyName.reviews).document(reviewId)
        
        let deleteResult: Result<Void, Error> = await withCheckedContinuation { continuation in
            reviewRef.delete { error in
                if let error {
                    continuation.resume(returning: .failure(error))
                    return
                }
                
                continuation.resume(returning: .success(()))
            }
        }
        
       switch deleteResult {
        case .success:
           do {
               try await updateReviewReferencesAfterDeletion(restaurantId: restaurantId, deletedReviewId: reviewId)
               return .success(())
           } catch {
               return .failure(error)
           }
        case .failure(let error):
            return .failure(error)
        }
    }
    // MARK: - Private
    private func updateReviewReferencesAfterDeletion(restaurantId: String, deletedReviewId: String) async throws {
        let restaurantRef = restaurantsDB.document(restaurantId)
        let snapshot = try await restaurantRef.getDocument()
        
        guard let restaurant = snapshot.data() else { throw AppError.decodingError.error }

        var updates: [String: String?] = [:]
        
        if let latestReview = restaurant[DataFieldKeyName.latestReviewId] as? String,
            latestReview == deletedReviewId {
            let newLatest = try await getLatestReview(restaurantId: restaurantId)
            updates[DataFieldKeyName.latestReviewId] = newLatest
        }

        if let highestReview = restaurant[DataFieldKeyName.highestReviewId] as? String,
            highestReview == deletedReviewId {
            let newHighest = try await getExtremeReview(restaurantId: restaurantId, highest: true)
            updates[DataFieldKeyName.highestReviewId] = newHighest
        }

        if let lowestReview = restaurant[DataFieldKeyName.lowestReviewId] as? String,
            lowestReview == deletedReviewId {
            let newLowest = try await getExtremeReview(restaurantId: restaurantId, highest: false)
            updates[DataFieldKeyName.lowestReviewId] = newLowest
        }

        if !updates.isEmpty {
            try await restaurantRef.updateData(updates as [String: Any])
        }
    }
    
    private func getLatestReview(restaurantId: String) async throws -> String? {
        let snapshot = try await restaurantsDB
            .document(restaurantId)
            .collection(DataFieldKeyName.reviews)
            .order(by: DataFieldKeyName.createdAt, descending: true)
            .limit(to: 1)
            .getDocuments()
        
        let review = try snapshot.documents.first?.data(as: Review.self).id
        return review
    }

    private func getExtremeReview(restaurantId: String, highest: Bool) async throws -> String? {
        let snapshot = try await restaurantsDB
            .document(restaurantId)
            .collection(DataFieldKeyName.reviews)
            .order(by: DataFieldKeyName.rating, descending: highest)
            .limit(to: 1)
            .getDocuments()
        
        let review = try snapshot.documents.first?.data(as: Review.self).id
        return review
    }
}
