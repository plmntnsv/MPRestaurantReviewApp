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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.restaurant.name
        setupTableView()
        
        Task {
            switch await viewModel.fetchReviews() {
            case .success:
                reviewsTableView.reloadData()
            case .failure(let error):
                ErrorHandler.showError(error, in: self)
            }
        }
    }
    
    private func setupTableView() {
        reviewsTableView.dataSource = self
        
        reviewsTableView.register(
            UINib(nibName: "\(ReviewTableViewCell.self)", bundle: nil),
            forCellReuseIdentifier: "\(ReviewTableViewCell.self)"
        )
//        reviewsTableView.register(UITableViewCell.self , forCellReuseIdentifier: "reviewCell")
    }
}

extension AllReviewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reviewsTableView.dequeueReusableCell(
            withIdentifier: "\(ReviewTableViewCell.self)"
        ) as! ReviewTableViewCell
        
        cell.selectionStyle = .none
        
        let reviewView = ReviewView.load(in: cell.reviewViewContainer)
        reviewView.setup(
            with: viewModel.reviews[indexPath.row].rating.asRating,
            text: viewModel.reviews[indexPath.row].comment,
            authorName: viewModel.reviews[indexPath.row].author,
            visited: viewModel.reviews[indexPath.row].visitDate
        )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
}
