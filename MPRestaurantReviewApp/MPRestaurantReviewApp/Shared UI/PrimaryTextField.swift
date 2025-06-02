//
//  PrimaryTextField.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 2.06.25.
//

import Foundation
import UIKit

final class PrimaryTextField: UITextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .white
        textColor = .black
    
        if let placeholder {
            attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.7)]
            )
        }
    }
}
