//
//  RestaurantsService.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 1.06.25.
//

import Foundation
import FirebaseFirestore

struct RestaurantSuccessDataResult {
    let restaurants: [Restaurant]
    let lastDocument: DocumentSnapshot?
}

struct ReviewsSuccessDataResult {
    let reviews: [Review]
    let lastDocument: DocumentSnapshot?
}

final class RestaurantsService {
    private let restaurantsDB = Firestore.firestore().collection("restaurants")
    var hasPendingUpdates = false
    
    func getRestaurant(withId id: String) async -> Result<Restaurant, Error> {
        do {
            let document = try await restaurantsDB.document(id).getDocument()
            let restaurant = try document.data(as: Restaurant.self)
            return .success(restaurant)
        } catch {
            return .failure(error)
        }
    }
    
    func addRestaurant(_ name: String) async -> Result<Void, Error> {
        let newRestaurant = Restaurant(name: name, averageRating: 0, ratingsCount: 0)
        
        do {
            try restaurantsDB.addDocument(from: newRestaurant)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func editRestaurant(_ restaurant: Restaurant) async -> Result<Void, Error> {
        let restaurantRef = restaurantsDB.document(restaurant.id!)
        
        do {
            try restaurantRef.setData(from: restaurant)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func deleteRestaurant(_ restaurant: Restaurant) async -> Result<Void, Error> {
        let restaurantRef = restaurantsDB.document(restaurant.id!)
        let reviewsRef = restaurantRef.collection("reviews")
        
        do {
            // Step 1: Delete all reviews
            try await deleteSubcollection(reviewsRef)
            
            // Step 2: Delete the restaurant document
            try await restaurantRef.delete()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    private func deleteSubcollection(_ subcollectionRef: CollectionReference, batchSize: Int = 10) async throws {
        let snapshot = try await subcollectionRef.limit(to: batchSize).getDocuments()
        
        guard !snapshot.documents.isEmpty else { return }

        let batch = subcollectionRef.firestore.batch()
        
        for document in snapshot.documents {
            batch.deleteDocument(document.reference)
        }

        try await batch.commit()

        try await deleteSubcollection(subcollectionRef, batchSize: batchSize)
    }
    
    func getAllRestaurants(
        limit: Int,
        startAfterDoc: DocumentSnapshot? = nil
    ) async -> Result<RestaurantSuccessDataResult, Error> {
        do {
            var restaurantsQuery = restaurantsDB.order(by: "averageRating", descending: true).limit(to: limit)
            
            if let lastDoc = startAfterDoc {
                restaurantsQuery = restaurantsQuery.start(afterDocument: lastDoc)
            }
            
            let snapshot = try await restaurantsQuery.getDocuments()
            
            var restaurants: [Restaurant] = []
            
            for doc in snapshot.documents {
                let id = doc.documentID
                let data = doc.data()
                
                guard let name = data["name"] as? String,
                      let averageRating = data["averageRating"] as? Double,
                      let ratingsCount = data["ratingsCount"] as? Int else {
                    return .failure(AppError.decodingError.error)
                }
                
                let restaurant = Restaurant(
                    id: id,
                    name: name,
                    averageRating: averageRating,
                    ratingsCount: ratingsCount,
                    highestReview: parseReview(from: data["highestReview"] as? [String: Any], restaurantId: id),
                    lowestReview: parseReview(from: data["lowestReview"] as? [String: Any], restaurantId: id),
                    latestReview: parseReview(from: data["latestReview"] as? [String: Any], restaurantId: id)
                )
                
                restaurants.append(restaurant)
            }
            
            return .success(
                RestaurantSuccessDataResult(
                    restaurants: restaurants,
                    lastDocument: snapshot.documents.last
                )
            )
        } catch {
            return .failure(error)
        }
    }
    
    // MARK: - Private
    private func parseReview(from data: [String: Any]?, restaurantId: String) -> Review? {
        guard let data,
              let comment = data["comment"] as? String,
              let restaurantId = data["restaurantId"] as? String,
              let userId = data["userId"] as? String,
              let rating = data["rating"] as? Double,
              let author = data["author"] as? String,
              let visitDate = data["visitDate"] as? Timestamp,
              let createdAt = data["createdAt"] as? Timestamp else {
            return nil
        }
        
        return Review(
            restaurantId: restaurantId,
            userId: userId,
            author: author,
            rating: rating,
            comment: comment,
            visitDate: visitDate.dateValue(),
            createdAt: createdAt.dateValue()
        )
    }
}
