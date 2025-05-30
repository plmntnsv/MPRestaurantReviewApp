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
    @IBOutlet private weak var usernameTextField: UITextField!
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
        
        [usernameTextField,
         passwordTextField,
         repeatPasswordTextField,
         firstNameTextField,
         lastNameTextField].forEach { $0?.delegate = self }
        
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func didTapSignUpButton(_ sender: Any) {
        
    }
}

// MARK: - UITextFieldDelegate
extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
