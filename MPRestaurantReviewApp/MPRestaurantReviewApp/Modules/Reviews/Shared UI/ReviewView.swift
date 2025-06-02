//
//  ReviewView.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 2.06.25.
//

import Foundation
import UIKit

final class ReviewView: UIView {
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var visitedDateLabel: UILabel!
    @IBOutlet private weak var authorNameLabel: UILabel!
    @IBOutlet private weak var commentTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commentTextView.layer.cornerRadius = 8
    }
    
    func setup(with rating: Double, text: String, authorName: String, visited: Date) {
        ratingLabel.text = String(rating)
        commentTextView.text = text
        authorNameLabel.text = authorName
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        visitedDateLabel.text = "Visited: \(dateFormatter.string(from: visited))"
    }
}
