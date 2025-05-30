//
//  RegistrationViewController.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 30.05.25.
//

import Foundation
import UIKit

final class RegistrationViewController: KeyboardResponsiveViewController {
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var repeatPasswordTextField: UITextField!
    @IBOutlet private weak var firstNameTextField: UITextField!
    @IBOutlet private weak var lastNameTextField: UITextField!
    @IBOutlet private weak var dateOfBirthPicker: UIDatePicker!
    override var contentScrollView: UIScrollView? { scrollView }
    override var screenOffsetOnKeyboardAppear: CGFloat { 50 }
    
    var viewModel: RegistrationViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Registration"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        [emailTextField,
         passwordTextField,
         repeatPasswordTextField,
         firstNameTextField,
         lastNameTextField].forEach { $0?.delegate = self }
        
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func didTapRegisterButton(_ sender: Any) {
        guard let email = emailTextField.text,
        let password = passwordTextField.text,
        let repeatPassword = repeatPasswordTextField.text,
        let firstName = firstNameTextField.text,
        let lastName = lastNameTextField.text else {
            // TODO: display alert
            return
        }
        
        guard password == repeatPassword else {
            // TODO: display alert
            return
        }
        
        Task {
            let result = await viewModel.registerUser(
                email: email,
                password: password,
                firstName: firstName,
                lastName: lastName
            )
            
            switch result {
            case .success:
                view.backgroundColor = .green
            case .failure(let error):
                view.backgroundColor = .red
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
