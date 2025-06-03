//
//  RestaurantsViewController.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 31.05.25.
//

import Foundation
import UIKit

final class RestaurantsViewController: BaseAppearanceViewController {
    @IBOutlet private weak var restaurantsTableView: UITableView!
    @IBOutlet private weak var addNewContainerView: UIView?
    let refreshControl = UIRefreshControl()
    var viewModel: RestaurantsViewModel!
    
    // MARK: - Lifecycle
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Restaurants"
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onReviewDeletedReviewNotificationReceived(_:)),
            name: .reviewDeleted,
            object: nil
        )
        
        if UserManager.shared.currentUser?.isAdmin == false {
            addNewContainerView?.removeFromSuperview()
        }
        
        setupTableView()
        setupRefreshControl()
        
        fetchData(refresh: true)
    }
    
    // MARK: - @IBAction
    @IBAction private func didTapAddNewRestaurant(_ sender: Any) {
        viewModel.showAddRestaurant()
    }
    
    //MARK: - Private
    private func fetchData(refresh: Bool = false) {
        let blockingView = view.block()
        
        Task {
            switch await viewModel.getNextRestaurants(shouldRefresh: refresh) {
            case .success:
                restaurantsTableView.reloadData()
            case .failure(let error):
                ErrorHandler.showError(error, in: self)
            }
            
            blockingView.removeFromSuperview()
        }
    }
    
    private func setupTableView() {
        restaurantsTableView.delegate = self
        restaurantsTableView.dataSource = self
        restaurantsTableView.register(
            UINib(nibName: "\(RestaurantTableViewCell.self)", bundle: nil),
            forCellReuseIdentifier: "\(RestaurantTableViewCell.self)"
        )
        
        restaurantsTableView.register(
            UINib(nibName: "\(LoadingTableViewCell.self)", bundle: nil),
            forCellReuseIdentifier: "\(LoadingTableViewCell.self)"
        )
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        restaurantsTableView.refreshControl = refreshControl
    }
    
    @objc private func refreshData() {
        fetchData(refresh: true)
        refreshControl.endRefreshing()
    }
    
    @objc private func onReviewDeletedReviewNotificationReceived(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let review = userInfo[NotificationUserInfoKey.review] as? Review,
           let restaurant = userInfo[NotificationUserInfoKey.restaurant] as? Restaurant,
            review.reviewId == restaurant.latestReviewId ||
            review.reviewId == restaurant.highestReviewId ||
            review.reviewId == restaurant.lowestReviewId {
            // TODO: refresh specific index only
            refreshData()
        }
    }
}

// MARK: - UITableViewDataSource
extension RestaurantsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.restaurants.isEmpty {
            0
        } else if viewModel.pagingIsComplete {
            viewModel.restaurants.count
        } else {
            viewModel.restaurants.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row <= viewModel.restaurants.count - 1 else {
            let cell = restaurantsTableView.dequeueReusableCell(
                withIdentifier: "\(LoadingTableViewCell.self)"
            ) as! LoadingTableViewCell
            
            return cell
        }
        
        let cell = restaurantsTableView.dequeueReusableCell(
            withIdentifier: "\(RestaurantTableViewCell.self)"
        ) as! RestaurantTableViewCell
        
        cell.selectionStyle = .none
        cell.setup(with: viewModel.restaurants[indexPath.row], delegate: self)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        65
    }
}

// MARK: - UITableViewDelegate
extension RestaurantsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell is LoadingTableViewCell {
            fetchData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.showRestaurantDetails(at: indexPath.row)
    }
}

// MARK: - RestaurantTableViewCellDelegate
extension RestaurantsViewController: RestaurantTableViewCellDelegate {
    func restaurantCellDidTapEdit(_ restaurant: Restaurant) {
        viewModel.goToEditRestaurant(restaurant)
    }
    
    func restaurantCellDidTapDelete(_ restaurant: Restaurant) {
        Task {
            switch await viewModel.deleteRestaurant(restaurant) {
            case .success():
                restaurantsTableView.reloadData()
            case .failure(let error):
                ErrorHandler.showError(error, in: self)
            }
        }
    }
}

// MARK: - AddRestaurantViewControllerDelegate
extension RestaurantsViewController: AddRestaurantViewControllerDelegate {
    func onEditRestaurant(_ restaurant: Restaurant) {
        viewModel.editRestaurant(restaurant)
        restaurantsTableView.reloadData()
    }
    
    func onAddNewRestaurant(_ restaurantId: String) {
        // fetch and add new restaurant to dataSource. For now - pull to refresh
    }
}
