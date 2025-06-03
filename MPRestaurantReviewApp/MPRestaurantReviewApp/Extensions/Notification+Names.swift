//
//  Notification+DataChange.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 3.06.25.
//

import Foundation

extension Notification.Name {
    static let reviewEdited = Notification.Name("reviewDidChange")
    static let reviewDeleted = Notification.Name("reviewDeleted")
    static let reviewAdded = Notification.Name("reviewAdded")
}

enum NotificationUserInfoKey {
    static let restaurant = "restaurant"
    static let review = "review"
}
