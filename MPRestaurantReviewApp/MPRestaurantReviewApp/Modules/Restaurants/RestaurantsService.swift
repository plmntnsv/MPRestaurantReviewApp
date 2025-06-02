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
    private let db = Firestore.firestore()
    var hasPendingUpdates = false
    
    func getRestaurant(withId id: String) async -> Result<Restaurant, Error> {
        do {
            let document = try await db.collection("restaurants").document(id).getDocument()
            let restaurant = try document.data(as: Restaurant.self)
            return .success(restaurant)
        } catch {
            return .failure(error)
        }
    }
    
    func addRestaurant(_ name: String) async -> Result<Void, Error> {
        let newRestaurant = Restaurant(name: name, averageRating: 0, ratingsCount: 0)
        
        do {
            try db.collection("restaurants").addDocument(from: newRestaurant)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func getAllRestaurants(
        limit: Int,
        startAfterDoc: DocumentSnapshot? = nil
    ) async -> Result<RestaurantSuccessDataResult, Error> {
        do {
            var restaurantsQuery = db.collection("restaurants")
                .order(by: "averageRating", descending: true)
                .limit(to: limit)
            
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
