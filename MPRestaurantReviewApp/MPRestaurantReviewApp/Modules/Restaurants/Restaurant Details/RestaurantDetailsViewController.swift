//
//  RestaurantDetailsViewController.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 1.06.25.
//

import Foundation
import UIKit

final class RestaurantDetailsViewController: BaseAppearanceViewController {
    private enum Constant {
        static let latestReviewTitle: String = "Latest review"
        static let highestReviewTitle: String = "Highest review"
        static let lowestReviewTitle: String = "Lowest review"
        static let noDataText: String = "N/A"
    }
    
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
        viewModel.didTapSeeAllReviews()
    }
    
    // MARK: - Private
    private func setupUI() {
        restaurantNameLabel.text = viewModel.restaurant.name
        restaurantRating.text = String(viewModel.restaurant.averageRating.asRating)
        
        // Latest review setup
        let didSetupLatest = setupReviewView(
            in: latestReviewContainerView,
            with: viewModel.restaurant.latestReview
        )
        let latestTitleText = didSetupLatest ?
            Constant.latestReviewTitle :
            "\(Constant.latestReviewTitle): \(Constant.noDataText)"
        latestReviewTitleLabel.text = latestTitleText
        
        // Highest review setup
        let didSetupHighest = setupReviewView(
            in: highestReviewContainerView,
            with: viewModel.restaurant.highestReview
        )
        let highestTitleText = didSetupHighest ?
            Constant.highestReviewTitle :
            "\(Constant.highestReviewTitle): \(Constant.noDataText)"
        highestReviewTitleLabel.text = highestTitleText
        
        // Lowest review setup
        let didSetupLowest = setupReviewView(
            in: lowestReviewContainerView,
            with: viewModel.restaurant.lowestReview
        )
        let lowestTitleText = didSetupLowest ?
            Constant.lowestReviewTitle :
            "\(Constant.lowestReviewTitle): \(Constant.noDataText)"
        lowestReviewTitleLabel.text = lowestTitleText
    }
    
    private func setupReviewView(in container: UIView, with review: Review?) -> Bool {
        guard let review else {
            container.isHidden = true
            return false
        }
        
        let reviewView = ReviewView.load(in: container)
        
        reviewView.setup(
            with: review.rating.asRating,
            text: review.comment,
            authorName: review.author,
            visited: review.visitDate
        )
        
        return true
    }
}
