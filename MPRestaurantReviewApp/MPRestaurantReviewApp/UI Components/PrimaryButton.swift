//
//  PrimaryButton.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 30.05.25.
//

import Foundation
import UIKit

class PrimaryButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStyle()
    }
    
    private func setupStyle() {
        var newConfig = UIButton.Configuration.filled()
        newConfig.baseBackgroundColor = .systemPink
        newConfig.baseForegroundColor = .white
        newConfig.cornerStyle = .medium
        newConfig.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 10,
            bottom: 10,
            trailing: 10
        )
        configuration = newConfig
        configuration?.titleTextAttributesTransformer =
            UIConfigurationTextAttributesTransformer { inc in
                var out = inc
                out.font = .systemFont(ofSize: 16, weight: .semibold)
                return out
            }
    }
}
