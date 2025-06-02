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
    @IBOutlet weak var restaurantRating: UILabel!
    @IBOutlet weak var latestReviewContainerView: UIView!
    @IBOutlet weak var highestReviewContainerView: UIView!
    @IBOutlet weak var lowestReviewContainerView: UIView!
    
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
        
        setupReviewView(in: latestReviewContainerView, with: viewModel.restaurant.latestReview)
        setupReviewView(in: highestReviewContainerView, with: viewModel.restaurant.highestReview)
        setupReviewView(in: lowestReviewContainerView, with: viewModel.restaurant.lowestReview)
    }
    
    private func setupReviewView(in container: UIView, with review: Review?) {
        guard let review else {
            view.isHidden = true
            return
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
    }
}
