//
//  RestaurantDetailsViewController.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 1.06.25.
//

import Foundation
import UIKit

final class RestaurantDetailsViewController: BaseAppearanceViewController {
    @IBOutlet private weak var restaurantNameLabel: UILabel!
    @IBOutlet private weak var restaurantRating: UILabel!
    @IBOutlet private weak var latestReviewTitleLabel: UILabel!
    @IBOutlet private weak var lowestReviewTitleLabel: UILabel!
    @IBOutlet private weak var highestReviewTitleLabel: UILabel!
    @IBOutlet private weak var latestReviewContainerView: UIView!
    @IBOutlet private weak var highestReviewContainerView: UIView!
    @IBOutlet private weak var lowestReviewContainerView: UIView!
    
    var viewModel: RestaurantDetailsViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
       setupUI()
    }
    
    // MARK: - IBActions
    @IBAction func addReviewButtonTapped(_ sender: Any) {
        viewModel.didTapAddReview()
    }
    
    @IBAction func seeAllButtonTapped(_ sender: Any) {
        print("See all reviews tapped")
    }
    
    // MARK: - Private
    private func setupUI() {
        restaurantNameLabel.text = viewModel.restaurant.name
        restaurantRating.text = String(viewModel.restaurant.avgRating)
        
        if !setupReviewView(in: latestReviewContainerView, with: viewModel.restaurant.latestReview) {
            latestReviewTitleLabel.text = "Latest review: N/A"
        }
        
        if !setupReviewView(in: highestReviewContainerView, with: viewModel.restaurant.highestReview) {
            highestReviewTitleLabel.text = "Highest review: N/A"
        }
        
        if !setupReviewView(in: lowestReviewContainerView, with: viewModel.restaurant.lowestReview) {
            lowestReviewTitleLabel.text = "Lowest review: N/A"
        }
    }
    
    private func setupReviewView(in container: UIView, with review: Review?) -> Bool {
        guard let review else {
            container.isHidden = true
            return false
        }
        
        let reviewView = Bundle.main.loadNibNamed(
            "\(ReviewView.self)",
            owner: self,
            options: nil
        )![0] as! ReviewView
        container.addSubview(reviewView)
        reviewView.attachEdgeAnchors(to: container)
        
        reviewView.setup(
            with: review.rating,
            text: review.comment,
            authorName: review.author,
            visited: review.createdAt
        )
        
        return true
    }
}
