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
    
    func addRestaurant(_ name: String) async -> Result<Void, Error> {
        let newRestaurant = Restaurant(name: name, avgRating: 0)
        
        do {
            try db.collection("restaurants").addDocument(from: newRestaurant)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func getAllRestaurants(
        startAfterDoc: DocumentSnapshot? = nil,
        limit: Int = 10
    ) async -> Result<RestaurantSuccessDataResult, Error> {
        do {
            var restaurantsQuery = db.collection("restaurants")
                .order(by: "avgRating", descending: true)
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
                      let avgRating = data["avgRating"] as? Double else {
                    return .failure(AppError.decodingError.error)
                }
                
                let restaurant = Restaurant(
                    id: id,
                    name: name,
                    avgRating: avgRating,
                    highestReview: parseReview(from: data["highestReview"] as? [String: Any]),
                    lowestReview: parseReview(from: data["lowestReview"] as? [String: Any]),
                    latestReview: parseReview(from: data["latestReview"] as? [String: Any])
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
    private func parseReview(from data: [String: Any]?) -> Review? {
        guard let data,
              let comment = data["comment"] as? String,
              let userId = data["userId"] as? DocumentReference,
              let rating = data["rating"] as? Double,
              let author = data["author"] as? String,
              let visitDateStr = data["visitDate"] as? String,
              let createdAt = data["createdAt"] as? Timestamp else {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy/MM/dd"
        
        guard let visitDate = dateFormatter.date(from: visitDateStr) else {
            return nil
        }
        
        return Review(
            userId: userId.path,
            author: author,
            rating: rating,
            comment: comment,
            visitDate: visitDate,
            createdAt: createdAt.dateValue()
        )
    }
}
