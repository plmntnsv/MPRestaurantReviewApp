//
//  RestaurantsViewController.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 31.05.25.
//

import Foundation
import UIKit

final class RestaurantsViewController: UIViewController {
    var viewModel: RestaurantsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Restaurants"
    }
}
