//
//  UIView+Utilities.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 31.05.25.
//

import Foundation
import UIKit

extension UIView {
    func attachEdgeAnchors(to view: UIView, insets: UIEdgeInsets = .zero) {
        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: insets.left
            ),
            self.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -insets.right
            ),
            self.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: insets.top
            ),
            self.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: -insets.bottom
            )
        ])
    }
    
    @discardableResult
    func block() -> BlockUIView {
        let blockingView = BlockUIView(frame: .zero)
        addSubview(blockingView)
        blockingView.attachEdgeAnchors(to: self)
        
        return blockingView
    }
}
