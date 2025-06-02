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
    var viewModel: RestaurantsViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Restaurants"
        
        let blockingView = view.block()
        
        if UserManager.shared.currentUser?.isAdmin == false {
            addNewContainerView?.removeFromSuperview()
        }
        
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
        
        Task {
            switch await viewModel.getNextRestaurants() {
            case .success:
                restaurantsTableView.reloadData()
            case .failure(let error):
                ErrorHandler.showError(error, in: self)
            }
            
            blockingView.removeFromSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Task {
            if await viewModel.refreshRestaurantsIfNeeded() {
                restaurantsTableView.reloadData()
            }
        }
    }
    
    // MARK: - @IBAction
    @IBAction private func didTapAddNewRestaurant(_ sender: Any) {
        viewModel.didTapAddButton()
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
            Task {
                switch await viewModel.getNextRestaurants() {
                case .success:
                    restaurantsTableView.reloadData()
                case .failure(let error):
                    ErrorHandler.showError(error, in: self)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRestaurant(at: indexPath.row)
    }
}

// MARK: - RestaurantTableViewCellDelegate
extension RestaurantsViewController: RestaurantTableViewCellDelegate {
    func restaurantCellDidTapEdit(_ restaurant: Restaurant) {
        viewModel.didTapEditRestaurant(restaurant)
    }
    
    func restaurantCellDidTapDelete(_ restaurant: Restaurant) {
        viewModel.didTapDeleteRestaurant(restaurant)
    }
}
