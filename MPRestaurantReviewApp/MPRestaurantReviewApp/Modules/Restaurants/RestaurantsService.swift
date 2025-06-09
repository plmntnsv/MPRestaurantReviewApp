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
    private let restaurantsDB = Firestore.firestore().collection(DataFieldKeyName.restaurants)
    
    func getRestaurant(withId id: String) async -> Result<Restaurant, Error> {
        do {
            let document = try await restaurantsDB.document(id).getDocument()
            let restaurant = try document.data(as: Restaurant.self)
            return .success(restaurant)
        } catch {
            return .failure(error)
        }
    }
    
    func addRestaurant(_ restaurant: Restaurant) async -> Result<String, Error> {
        do {
            let ref = try restaurantsDB.addDocument(from: restaurant)
            
            return .success(ref.documentID)
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
        let reviewsRef = restaurantRef.collection(DataFieldKeyName.reviews)
        
        do {
            // Delete all reviews
            try await deleteSubcollection(reviewsRef)
            
            // Delete the restaurant document
            try await restaurantRef.delete()
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
            var restaurantsQuery = restaurantsDB.order(by: DataFieldKeyName.averageRating, descending: true).limit(to: limit)
            
            if let lastDoc = startAfterDoc {
                restaurantsQuery = restaurantsQuery.start(afterDocument: lastDoc)
            }
            
            let snapshot = try await restaurantsQuery.getDocuments()
            
            var restaurants: [Restaurant] = []
            
            for doc in snapshot.documents {
                let id = doc.documentID
                let data = doc.data()
                
                guard let name = data[DataFieldKeyName.name] as? String,
                      let averageRating = data[DataFieldKeyName.averageRating] as? Double,
                      let ratingsCount = data[DataFieldKeyName.ratingsCount] as? Int else {
                    return .failure(AppError.decodingError.error)
                }
                
                let restaurant = Restaurant(
                    id: id,
                    name: name,
                    averageRating: averageRating,
                    ratingsCount: ratingsCount,
                    highestReviewId: data[DataFieldKeyName.highestReviewId] as? String,
                    lowestReviewId: data[DataFieldKeyName.lowestReviewId] as? String,
                    latestReviewId: data[DataFieldKeyName.latestReviewId] as? String
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
    
    func getRestaurantKeyReviews(_ restaurant: Restaurant) async -> RestaurantDetailsKeyReviews {
        let restaurantRef = restaurantsDB.document(restaurant.id!)
        let reviewsRef = restaurantRef.collection(DataFieldKeyName.reviews)
        
        var latest: Review?
        var highest: Review?
        var lowest: Review?
        if let latestId = restaurant.latestReviewId {
            latest = try? await reviewsRef.document(latestId).getDocument(as: Review.self)
        }
        
        if let highestId = restaurant.highestReviewId {
            highest = try? await reviewsRef.document(highestId).getDocument(as: Review.self)
        }
        
        if let lowestId = restaurant.lowestReviewId {
            lowest = try? await reviewsRef.document(lowestId).getDocument(as: Review.self)
        }
        
        return RestaurantDetailsKeyReviews(latest: latest, highest: highest, lowest: lowest)
    }
    
    // MARK: - Private
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
}
