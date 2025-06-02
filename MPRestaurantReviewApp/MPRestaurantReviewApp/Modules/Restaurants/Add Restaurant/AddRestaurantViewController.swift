//
//  AddRestaurantViewController.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 1.06.25.
//

import Foundation
import UIKit

final class AddRestaurantViewController: KeyboardResponsiveViewController {
    @IBOutlet private weak var restaurantNameTextField: UITextField!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    override var contentScrollView: UIScrollView? {
        return scrollView
    }
    
    var viewModel: AddRestaurantViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add New Restaurant"
    }
    
    // MARK: - IBActions
    @IBAction private func didTapAddButton(_ sender: Any) {
        guard let name = restaurantNameTextField.text, !name.isEmpty else {
            ErrorHandler.showError(
                AppError.badInput(additionalInfo: "Restaurant name cannot be empty"),
                in: self
            )
            return
        }
        
        Task {
            switch await viewModel.addRestaurant(name: name) {
            case .success:
                viewModel.didAddRestaurant()
            case .failure(let error):
                ErrorHandler.showError(error, in: self)
            }
        }
    }
}
