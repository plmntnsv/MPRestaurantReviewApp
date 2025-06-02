//
//  BaseTabBarController.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 1.06.25.
//

import Foundation
import UIKit

class BaseTabBarController: UITabBarController {
    private var tabBarAppearance: UITabBarAppearance {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .backgroundColor1
        
        return appearance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.isTranslucent = false
        tabBar.backgroundColor = UIColor.backgroundColor1
        
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
    }
}
