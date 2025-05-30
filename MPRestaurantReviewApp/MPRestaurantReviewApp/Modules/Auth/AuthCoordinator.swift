//
//  AuthCoordinator.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 29.05.25.
//

import Foundation
import UIKit

final class AuthCoordinator: Coordinator {
    private var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showLogin()
    }
    
    func showLogin() {
        let viewModel = LoginViewModel(coordinator: self)
        let viewController = LoginViewController(nibName: "\(LoginViewController.self)", bundle: nil)
        viewController.viewModel = viewModel
        
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func showRegistration() {
        let viewModel = RegistrationViewModel(coordinator: self)
        let viewController = RegistrationViewController(
            nibName: "\(RegistrationViewController.self)",
            bundle: nil
        )
        viewController.viewModel = viewModel
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func didFinishLogin() {
        appCoordinator.startMainFlow()
    }
}
