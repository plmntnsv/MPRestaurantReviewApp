//
//  AuthCoordinator.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 29.05.25.
//

import Foundation
import UIKit

final class AuthCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let window: UIWindow

    init(navigationController: UINavigationController, in window: UIWindow) {
        self.navigationController = navigationController
        self.window = window
    }

    override func start() {
        showLogin()
    }
    
    func showLogin() {
        let viewModel = LoginViewModel(coordinator: self, service: AuthService())
        let viewController = LoginViewController(nibName: "\(LoginViewController.self)", bundle: nil)
        viewController.viewModel = viewModel
        
        window.rootViewController = navigationController
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func showRegistration() {
        let viewModel = RegistrationViewModel(coordinator: self, service: AuthService())
        let viewController = RegistrationViewController(
            nibName: "\(RegistrationViewController.self)",
            bundle: nil
        )
        viewController.viewModel = viewModel
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func didFinishLogin() {
        DispatchQueue.main.async {
            self.appCoordinator.startMainFlow()
        }
    }
}
