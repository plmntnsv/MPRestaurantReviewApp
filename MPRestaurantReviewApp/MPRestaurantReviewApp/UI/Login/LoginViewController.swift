//
//  LoginViewController.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 28.05.25.
//

import Foundation
import UIKit

final class LoginViewController: UIViewController {
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var containerStackView: UIStackView!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    weak var viewModel: LoginViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        loginButton.layer.cornerRadius = 10
        
        let signUpBtnAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.secondaryLabel,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        let attributeString = NSMutableAttributedString(
            string: "Don't have an account? Sign up",
            attributes: signUpBtnAttributes
        )
        
        signUpButton.setAttributedTitle(attributeString, for: .normal)
        
//        let guide = view.keyboardLayoutGuide
//        guide.followsUndockedKeyboard = true
//        
//        containerStackView.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            containerStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            containerStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            containerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
//            containerStackView.bottomAnchor.constraint(equalTo: guide.topAnchor, constant: -12)
//        ])
//        
//        
    }
    
    @IBAction private func didTapLoginButton(_ sender: Any) {
        print("LOGIN")
    }
    
    @IBAction private func didTapSignUpButton(_ sender: Any) {
        print("SIGN UP")
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
