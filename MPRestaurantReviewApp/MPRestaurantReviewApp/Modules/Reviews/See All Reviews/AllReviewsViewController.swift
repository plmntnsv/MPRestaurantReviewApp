//
//  AllReviewsViewController.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 2.06.25.
//

import Foundation
import UIKit

final class AllReviewsViewController: BaseAppearanceViewController {
    @IBOutlet private weak var reviewsTableView: UITableView!
    var viewModel: AllReviewsViewModel!
    
    // MARK: - Lifecycle
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.restaurant.name
        setupTableView()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onReviewEditedNotificationReceived(_:)),
            name: .reviewEdited,
            object: nil
        )
        
        fetchData()
    }
    
    // MARK: - Private
    private func setupTableView() {
        reviewsTableView.dataSource = self
        reviewsTableView.delegate = self
        
        reviewsTableView.register(
            UINib(nibName: "\(ReviewTableViewCell.self)", bundle: nil),
            forCellReuseIdentifier: "\(ReviewTableViewCell.self)"
        )
        
        reviewsTableView.register(
            UINib(nibName: "\(LoadingTableViewCell.self)", bundle: nil),
            forCellReuseIdentifier: "\(LoadingTableViewCell.self)"
        )
    }
    
    @objc private func onReviewEditedNotificationReceived(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let review = userInfo[NotificationUserInfoKey.review] as? Review,
              let restaurant = userInfo[NotificationUserInfoKey.restaurant] as? Restaurant,
              restaurant.id == viewModel.restaurant.id else {
            return
        }
        
        if viewModel.updateExistingReview(with: review) {
            reviewsTableView.reloadData()
        }
    }
    
    private func fetchData() {
        Task {
            switch await viewModel.fetchReviews() {
            case .success:
                reviewsTableView.reloadData()
            case .failure(let error):
                ErrorHandler.showError(error, in: self)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension AllReviewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.reviews.isEmpty {
            0
        } else if viewModel.pagingIsComplete {
            viewModel.reviews.count
        } else {
            viewModel.reviews.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row <= viewModel.reviews.count - 1 else {
            let cell = reviewsTableView.dequeueReusableCell(
                withIdentifier: "\(LoadingTableViewCell.self)"
            ) as! LoadingTableViewCell
            
            return cell
        }
        
        let cell = reviewsTableView.dequeueReusableCell(
            withIdentifier: "\(ReviewTableViewCell.self)"
        ) as! ReviewTableViewCell
        
        cell.selectionStyle = .none
        
        cell.setup(delegate: self, review: viewModel.reviews[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UserManager.shared.currentUser!.isAdmin ? 169 : 128
    }
}

// MARK: - UITableViewDelegate
extension AllReviewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell is LoadingTableViewCell {
            Task {
                switch await viewModel.fetchReviews() {
                case .success:
                    reviewsTableView.reloadData()
                case .failure(let error):
                    ErrorHandler.showError(error, in: self)
                }
            }
        }
    }
}

// MARK: - ReviewTableViewCellDelegate
extension AllReviewsViewController: ReviewTableViewCellDelegate {
    func reviewTableViewCell(_ cell: ReviewTableViewCell, didTapEditButtonFor review: Review) {
        viewModel.showEditReview(review)
    }
    
    func reviewTableViewCell(_ cell: ReviewTableViewCell, didTapDeleteButtonFor review: Review) {
        Task {
            switch await viewModel.deleteReview(review) {
            case .success:
                NotificationCenter.default.post(
                    name: .reviewDeleted,
                    object: nil,
                    userInfo: [
                        NotificationUserInfoKey.review: review,
                        NotificationUserInfoKey.restaurant: viewModel.restaurant
                    ]
                )
                reviewsTableView.reloadData()
            case .failure(let error):
                ErrorHandler.showError(error, in: self)
            }
        }
    }
}
