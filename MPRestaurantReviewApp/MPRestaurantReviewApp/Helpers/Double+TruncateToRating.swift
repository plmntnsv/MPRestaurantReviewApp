//
//  Double+Truncate.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 2.06.25.
//

import Foundation

extension Double {
    var asRating: Double { ceil(self * 10) / 10 }
}
