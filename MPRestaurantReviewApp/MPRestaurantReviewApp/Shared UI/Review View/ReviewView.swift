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
    
    func setup(with rating: Double, text: String, authorName: String, visited: Date) {
        ratingLabel.text = String(rating)
        commentTextView.text = text
        authorNameLabel.text = authorName
        visitedDateLabel.text = "Visited: \(visited.asAppFormat)"
    }
    
    static func load(in container: UIView) -> ReviewView {
        let reviewView = Bundle.main.loadNibNamed(
            "\(ReviewView.self)",
            owner: self,
            options: nil
        )![0] as! ReviewView
        container.addSubview(reviewView)
        reviewView.attachEdgeAnchors(to: container)
        
        return reviewView
    }
}
