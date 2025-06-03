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
        static let latestReviewTitle: String = "Latest review:"
        static let highestReviewTitle: String = "Highest review:"
        static let lowestReviewTitle: String = "Lowest review:"
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
    private lazy var blockView: BlockUIView = {
        let blockView = BlockUIView()
        blockView.isHidden = true
        blockView.isUserInteractionEnabled = false
        view.addSubview(blockView)
        blockView.attachEdgeAnchors(to: view)
        
        return blockView
    }()
    
    var viewModel: RestaurantDetailsViewModel!
    
    // MARK: - Lifecycle
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onReviewAddedNotificationReceived(_:)),
            name: .reviewAdded,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onReviewDeletedNotificationReceived(_:)),
            name: .reviewDeleted,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onReviewEditedNotificationReceived(_:)),
            name: .reviewEdited,
            object: nil
        )
        
        fetchRestaurantData()
    }
    
    // MARK: - IBActions
    @IBAction func addReviewButtonTapped(_ sender: Any) {
        viewModel.showAddReview()
    }
    
    @IBAction func seeAllButtonTapped(_ sender: Any) {
        viewModel.showSeeAllReviews()
    }
    
    // MARK: - Private
    private func setupUI() {
        restaurantNameLabel.text = viewModel.restaurant.name
        restaurantRating.text = String(viewModel.restaurant.averageRating.asRating)
        
        // Latest review setup
        let didSetupLatest = setupReviewView(
            in: latestReviewContainerView,
            with: viewModel.keyReviews?.latest
        )
        let latestTitleText = didSetupLatest ?
            Constant.latestReviewTitle :
            "\(Constant.latestReviewTitle) \(Constant.noDataText)"
        latestReviewTitleLabel.text = latestTitleText
        
        // Highest review setup
        let didSetupHighest = setupReviewView(
            in: highestReviewContainerView,
            with: viewModel.keyReviews?.highest
        )
        let highestTitleText = didSetupHighest ?
            Constant.highestReviewTitle :
            "\(Constant.highestReviewTitle) \(Constant.noDataText)"
        highestReviewTitleLabel.text = highestTitleText
        
        // Lowest review setup
        let didSetupLowest = setupReviewView(
            in: lowestReviewContainerView,
            with: viewModel.keyReviews?.lowest
        )
        let lowestTitleText = didSetupLowest ?
            Constant.lowestReviewTitle :
            "\(Constant.lowestReviewTitle) \(Constant.noDataText)"
        lowestReviewTitleLabel.text = lowestTitleText
    }
    
    private func setupReviewView(in container: UIView, with review: Review?) -> Bool {
        guard let review else {
            container.isHidden = true
            return false
        }
        
        container.isHidden = false
        let reviewView = ReviewView.load(in: container)
        
        reviewView.setup(
            with: review.rating.asRating,
            text: review.comment,
            authorName: review.author,
            visited: review.visitDate
        )
        
        return true
    }
    
    @objc private func onReviewAddedNotificationReceived(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let restaurant = userInfo[NotificationUserInfoKey.restaurant] as? Restaurant,
              restaurant.id == viewModel.restaurant.id else {
            return
        }
        
        fetchRestaurantData()
    }
    
    @objc private func onReviewDeletedNotificationReceived(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let restaurant = userInfo[NotificationUserInfoKey.restaurant] as? Restaurant,
              restaurant.id == viewModel.restaurant.id else {
            return
        }
        
        fetchRestaurantData()
    }
    
    @objc private func onReviewEditedNotificationReceived(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let restaurant = userInfo[NotificationUserInfoKey.restaurant] as? Restaurant,
              restaurant.id == viewModel.restaurant.id else {
            return
        }
        
        fetchRestaurantData()
    }
    
    private func fetchRestaurantData() {
        blockView.isHidden = false
        Task {
            switch await viewModel.getRestaurant() {
            case .success:
                await viewModel.getKeyReviews()
                setupUI()
            case .failure(let error):
                ErrorHandler.showError(error, in: self)
            }
            
            blockView.isHidden = true
        }
    }
}
