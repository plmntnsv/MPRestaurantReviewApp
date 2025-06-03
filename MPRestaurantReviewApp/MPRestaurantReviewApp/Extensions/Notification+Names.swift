//
//  Notification+DataChange.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 3.06.25.
//

import Foundation

extension Notification.Name {
    static let restaurantDidChange = Notification.Name("restaurantDidChange")
    static let reviewDidChange = Notification.Name("reviewDidChange")
    
    static let restaurantDeleted = Notification.Name("restaurantDeleted")
    static let reviewDeleted = Notification.Name("reviewDeleted")
    
    static let restaurantAdded = Notification.Name("restaurantAdded")
    static let reviewAdded = Notification.Name("reviewAdded")
}
