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
    @IBOutlet private weak var contentScrollView: UIScrollView!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    weak var viewModel: LoginViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        setupButtons()
        
        let dismissKeyboardTap = UITapGestureRecognizer(
            target: self,
            action: #selector(UIInputViewController.dismissKeyboard)
        )
        view.addGestureRecognizer(dismissKeyboardTap)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillAppear),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillDisappear),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    // MARK: - UI Setup
    private func setupButtons() {
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
    }
    
    // MARK: - IBActions
    @IBAction private func didTapLoginButton(_ sender: Any) {
        print("LOGIN")
    }
    
    @IBAction private func didTapSignUpButton(_ sender: Any) {
        print("SIGN UP")
    }
    
    // MARK: - Keyboard Management
    @objc private func keyboardWillAppear() {
        guard contentScrollView.contentOffset.y == 0 else { return }
        contentScrollView.contentOffset.y += 100
    }
    
    @objc private func keyboardWillDisappear() {
        contentScrollView.contentOffset.y = 0
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}
