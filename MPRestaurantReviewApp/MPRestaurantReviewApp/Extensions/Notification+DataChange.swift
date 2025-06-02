//
//  Notification+DataChange.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 3.06.25.
//

import Foundation

extension Notification.Name {
    static let restaurantDidChang = Notification.Name("restaurantChangedName")
    static let reviewDidChange = Notification.Name("reviewDidChangeName")
    
    static let restaurantDeleted = Notification.Name("restaurantDeletedName")
    static let reviewDeleted = Notification.Name("reviewDeletedName")
    
    static let restaurantAdded = Notification.Name("restaurantAddedName")
    static let reviewAdded = Notification.Name("reviewAddedName")
}
