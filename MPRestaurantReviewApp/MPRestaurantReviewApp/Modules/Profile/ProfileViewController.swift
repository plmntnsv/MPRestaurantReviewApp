//
//  ProfileViewController.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 31.05.25.
//

import Foundation
import UIKit

final class ProfileViewController: BaseAppearanceViewController {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var adminLabel: UILabel!
    @IBOutlet private weak var dataDeletionButtonsContainerView: UIView!
    var viewModel: ProfileViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = "\(viewModel.currentUser!.firstName) \(viewModel.currentUser!.lastName)"
        emailLabel.text = viewModel.currentUser!.email
        adminLabel.isHidden = !viewModel.currentUser!.isAdmin
        dataDeletionButtonsContainerView.isHidden = !viewModel.currentUser!.isAdmin
        
        navigationItem.title = "Profile"
    }
    
    @IBAction private func didTabLogoutButton(_ sender: Any) {
        let blockView = view.block()
        switch viewModel.logout() {
        case .success():
            viewModel.userDidLogout()
        case .failure(let error):
            blockView.removeFromSuperview()
            ErrorHandler.showError(error, in: self)
        }
    }
    
    @IBAction private func didTapDeleteRestaurants(_ sender: Any) {
        
    }
    
    @IBAction private func didTapDeleteReviews(_ sender: Any) {
        
    }
    
    @IBAction private func didTapDeleteEverything(_ sender: Any) {
        
    }
}
