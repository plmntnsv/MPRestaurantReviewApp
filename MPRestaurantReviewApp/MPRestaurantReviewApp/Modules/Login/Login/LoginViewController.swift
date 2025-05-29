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
    @IBOutlet private weak var appIconBackgroundView: UIView!
    
    var viewModel: LoginViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        setupUI()
        setupKeyboardObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
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
    
    private func setupKeyboardObserver() {
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
    
    // MARK: - IBActions
    @IBAction private func didTapLoginButton(_ sender: Any) {
        guard let username = usernameTextField.text,
              let password = passwordTextField.text else {
            return
        }
        
        print("username: \(username), password: \(password)")
        
        viewModel.login(username: username, password: password)
    }
    
    @IBAction private func didTapSignUpButton(_ sender: Any) {
        viewModel.register()
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

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
