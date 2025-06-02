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
    var viewModel: RestaurantsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Restaurants"
        
        let blockingView = view.block()
        
        restaurantsTableView.delegate = self
        restaurantsTableView.dataSource = self
        restaurantsTableView.register(
            UINib(nibName: "\(RestaurantTableViewCell.self)", bundle: nil),
            forCellReuseIdentifier: "restaurantCell"
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
}

extension RestaurantsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = restaurantsTableView.dequeueReusableCell(withIdentifier: "restaurantCell") as! RestaurantTableViewCell
        
        cell.titleLabel.text = "\(viewModel.restaurants[indexPath.row].name) - \(viewModel.restaurants[indexPath.row].avgRating)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}

extension RestaurantsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRestaurant(at: indexPath.row)
    }
}
