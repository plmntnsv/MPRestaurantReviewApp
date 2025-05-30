//
//  ActionButton.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 30.05.25.
//

import Foundation
import UIKit

class ActionButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStyle()
    }
    private func setupStyle() {
        backgroundColor = .systemPink
        setTitleColor(.screenFG, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
}
