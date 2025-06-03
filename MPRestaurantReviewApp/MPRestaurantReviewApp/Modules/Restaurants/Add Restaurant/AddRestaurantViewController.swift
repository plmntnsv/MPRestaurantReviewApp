//
//  AddRestaurantViewController.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 1.06.25.
//

import Foundation
import UIKit

protocol AddRestaurantViewControllerDelegate: AnyObject {
    func onEditRestaurant(_ restaurant: Restaurant)
    func onAddNewRestaurant(_ restaurantId: String)
}

final class AddRestaurantViewController: KeyboardResponsiveViewController {
    enum ScreenType {
        case add
        case edit(_ restaurant: Restaurant)
    }
    @IBOutlet private weak var restaurantNameLabel: UILabel!
    @IBOutlet private weak var restaurantNameTextField: UITextField!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var addButton: PrimaryButton!
    
    override var contentScrollView: UIScrollView? {
        return scrollView
    }
    
    var screenType: ScreenType = .add
    var viewModel: AddRestaurantViewModel!
    weak var delegate: AddRestaurantViewControllerDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - IBActions
    @IBAction private func didTapAddButton(_ sender: Any) {
        guard let name = restaurantNameTextField.text, !name.isEmpty else {
            ErrorHandler.showError(
                AppError.badInput(additionalInfo: "Restaurant name cannot be empty").error,
                in: self
            )
            return
        }
        
        switch screenType {
        case .add:
            Task {
                switch await viewModel.addRestaurant(name: name) {
                case .success(let id):
                    delegate?.onAddNewRestaurant(id)
                    viewModel.didAddRestaurant()
                case .failure(let error):
                    ErrorHandler.showError(error, in: self)
                }
            }
        case .edit(let restaurant):
            guard restaurant.name != name else {
                ErrorHandler.showError(
                    AppError.badInput(additionalInfo: "New name cannot be the same as the old name").error,
                    in: self
                )
                return
            }
            
            Task {
                switch await viewModel.editRestaurant(restaurant, newName: name) {
                case .success(let restaurant):
                    delegate?.onEditRestaurant(restaurant)
                    viewModel.didEditRestaurant(restaurant)
                case .failure(let error):
                    ErrorHandler.showError(error, in: self)
                }
            }
        }
        
    }
    
    // MARK: - Private
    private func setupUI() {
        switch screenType {
        case .add:
            restaurantNameLabel.text = "Restaurant Name:"
            addButton.setTitle("Add", for: .normal)
            title = "Add New Restaurant"
        case .edit(let restaurant):
            restaurantNameLabel.text = "Edit Name:"
            restaurantNameTextField.text = restaurant.name
            addButton.setTitle("Edit", for: .normal)
            title = restaurant.name
        }
    }
}
