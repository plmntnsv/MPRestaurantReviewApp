//
//  ReviewTableViewCell.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 1.06.25.
//

import Foundation
import UIKit

protocol ReviewTableViewCellDelegate: AnyObject {
    func reviewTableViewCell(_ cell: ReviewTableViewCell, didTapEditButtonFor review: Review)
    func reviewTableViewCell(_ cell: ReviewTableViewCell, didTapDeleteButtonFor review: Review)
}

final class ReviewTableViewCell: UITableViewCell {
    @IBOutlet private weak var reviewViewContainer: UIView!
    @IBOutlet private weak var actionButtonsStackView: UIStackView?
    private weak var delegate: ReviewTableViewCellDelegate?
    private var review: Review?
    
    func setup(delegate: ReviewTableViewCellDelegate, review: Review) {
        self.delegate = delegate
        self.review = review
        if !UserManager.shared.currentUser!.isAdmin {
            actionButtonsStackView?.removeFromSuperview()
        }
        
        let reviewView = ReviewView.load(in: reviewViewContainer)
        reviewView.setup(
            with: review.rating.asRating,
            text: review.comment,
            authorName: review.author,
            visited: review.visitDate
        )
    }
    
    @IBAction private func didTapEditButton(_ sender: Any) {
        guard let delegate, let review else { return }
        delegate.reviewTableViewCell(self, didTapEditButtonFor: review)
    }
    
    @IBAction private func didTapDeleteButton(_ sender: Any) {
        guard let delegate, let review else { return }
        delegate.reviewTableViewCell(self, didTapDeleteButtonFor: review)
    }
    
}
