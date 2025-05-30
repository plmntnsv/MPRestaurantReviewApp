//
//  LoginViewController.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 28.05.25.
//

import Foundation
import UIKit

final class LoginViewController: KeyboardResponsiveViewController {
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var appIconBackgroundView: UIView!
    
    override var contentScrollView: UIScrollView? { scrollView }
    
    var viewModel: LoginViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        dismissKeyboard()
    }
    
    // MARK: - Setup
    private func setupUI() {
        appIconBackgroundView.layer.cornerRadius = appIconBackgroundView.frame.height / 2
        loginButton.layer.cornerRadius = 10
        
        let signUpBtnAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.white,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        let attributeString = NSMutableAttributedString(
            string: "Don't have an account? Sign up!",
            attributes: signUpBtnAttributes
        )
        
        signUpButton.setAttributedTitle(attributeString, for: .normal)
    }
    
    // MARK: - IBActions
    @IBAction private func didTapLoginButton(_ sender: Any) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            return
        }
        
        Task {
            let result = await viewModel.loginUser(email: email, password: password)
            
            switch result {
            case .success:
                view.backgroundColor = .green
            case .failure(let error):
                view.backgroundColor = .red
            }
        }
    }
    
    @IBAction private func didTapSignUpButton(_ sender: Any) {
        viewModel.showRegistration()
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
