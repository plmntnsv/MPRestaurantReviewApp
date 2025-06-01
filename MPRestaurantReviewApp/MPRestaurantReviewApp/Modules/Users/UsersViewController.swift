//
//  UsersViewController.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 31.05.25.
//

import Foundation
import UIKit

final class UsersViewController: UIViewController {
    var viewModel: UsersViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Users"
    }
}
