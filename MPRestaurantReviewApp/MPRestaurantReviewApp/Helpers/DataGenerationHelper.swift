//
//  DataGenerationHelper.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 4.06.25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

final class DataGenerationHelper {
    struct TestUser {
        let email: String
        let password: String
        let firstName: String
        let lastName: String
        let role: String
    }

    struct TestReview {
        let author: String
        let comment: String
        let createdAt: Date
        let rating: Double
        let userId: String
        let visitDate: Date
    }

    static func populateData() async {
        let db = Firestore.firestore()
        let auth = Auth.auth()
        let now = Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 4, hour: 12))!
        
        let firstNamesPool = ["Liam", "Olivia", "Noah", "Emma", "Oliver", "Ava", "Elijah", "Sophia", "William", "Isabella"]
        let lastNamesPool = ["Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller", "Davis", "Rodriguez", "Martinez"]

        // MARK: - 1. Create Users
        let testUsers: [TestUser] = (1...10).map {
            TestUser(
                email: "\(firstNamesPool[$0-1])@a.com".lowercased(),
                password: "123456",
                firstName: "\(firstNamesPool[$0-1])",
                lastName: "\(lastNamesPool[$0-1])",
                role: "user"
            )
        }
        
        var userIdList: [String] = []
        
        for user in testUsers {
            do {
                let result = try await auth.createUser(withEmail: user.email, password: user.password)
                let userId = result.user.uid
                userIdList.append(userId)
                
                try await db.collection("users").document(userId).setData([
                    "email": user.email,
                    "firstName": user.firstName,
                    "lastName": user.lastName,
                    "role": user.role
                ])
            } catch {
                print("Failed to create user \(user.email): \(error.localizedDescription)")
            }
        }
        
        // MARK: - 2. Create Restaurants and Reviews
        let restaurantNames: [String] = ["Pizza Hut", "McDonald's", "KFC", "Subway", "Burger King", "Wendy's", "Five Guys Burgers and Fries", "Chick-fil-A", "Taco Bell", "Dairy Queen", "Happy", "Burger Place", "Salad Place", "Sushi Place", "Burrata", "Shtastliveca", "Pizzeria", "Pizzeria Roma", "Pizzeria Napoletana", "The Corner"]
        for i in 1...20 {
            let restaurantRef = db.collection("restaurants").document()
            let name = restaurantNames[i - 1]
            
            // Create 3-7 reviews per restaurant
            let numberOfReviews = Int.random(in: 3...7)
            var reviews: [(id: String, data: TestReview)] = []
            
            for _ in 0..<numberOfReviews {
                let userIndex = Int.random(in: 0..<userIdList.count)
                let userId = userIdList[userIndex]
                let author = "\(testUsers[userIndex].firstName) \(testUsers[userIndex].lastName)"
                let rating = Double(Int.random(in: 10...50)) / 10.0
                let createdAt = now.addingTimeInterval(Double.random(in: -10_000_000...0))
                let visitDate = createdAt.addingTimeInterval(Double.random(in: -1_000_000...0))
                let comment = "Test comment with rating \(rating)"
                
                let review = TestReview(
                    author: author,
                    comment: comment,
                    createdAt: createdAt,
                    rating: rating,
                    userId: userId,
                    visitDate: visitDate
                )
                
                let reviewRef = restaurantRef.collection("reviews").document()
                let reviewId = reviewRef.documentID
                
                do {
                    try await reviewRef.setData([
                        "author": review.author,
                        "comment": review.comment,
                        "createdAt": review.createdAt,
                        "rating": review.rating,
                        "userId": review.userId,
                        "visitDate": review.visitDate
                    ])
                    reviews.append((id: reviewId, data: review))
                } catch {
                    print("Failed to write review: \(error)")
                }
            }
            
            // Compute average, highest, lowest, and latest
            let averageRating = reviews.map { $0.data.rating }.reduce(0, +) / Double(reviews.count)
            let highest = reviews.max(by: { $0.data.rating < $1.data.rating })!
            let lowest = reviews.min(by: { $0.data.rating < $1.data.rating })!
            let latest = reviews.min(by: { abs($0.data.createdAt.timeIntervalSince(now)) < abs($1.data.createdAt.timeIntervalSince(now)) })!
            
            do {
                try await restaurantRef.setData([
                    "name": name,
                    "averageRating": averageRating,
                    "ratingsCount": reviews.count,
                    "highestReviewId": highest.id,
                    "lowestReviewId": lowest.id,
                    "latestReviewId": latest.id
                ])
            } catch {
                print("Failed to write restaurant: \(error)")
            }
        }
        
        print("✅ Data population completed.")
    }
}
