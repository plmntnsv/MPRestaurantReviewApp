//
//  KeyboardResponsiveViewController.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 30.05.25.
//

import Foundation
import UIKit

class KeyboardResponsiveViewController: BaseAppearanceViewController {
    var screenOffsetOnKeyboardAppear: CGFloat { 100 }
    var contentScrollView: UIScrollView? {
        fatalError("Subclasses must override contentScrollView")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboardObserver()
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
    
    // MARK: - Keyboard Management
    @objc private func keyboardWillAppear() {
        guard let contentScrollView, contentScrollView.contentOffset.y == 0 else { return }
        contentScrollView.contentOffset.y += screenOffsetOnKeyboardAppear
    }
    
    @objc private func keyboardWillDisappear() {
        contentScrollView?.contentOffset.y = 0
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
