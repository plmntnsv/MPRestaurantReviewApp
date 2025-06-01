//
//  BaseNavigationController.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 1.06.25.
//

import Foundation
import UIKit

class BaseNavigationController: UINavigationController {
    private var appearance: UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .screenBG
        appearance.titleTextAttributes = [.foregroundColor: UIColor.screenFG]
        appearance.backgroundImage = nil
        
        return appearance
    }
    
    init(tabBarImage: String, selectedTabBarImage: String) {
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: tabBarImage)?.withTintColor(.white, renderingMode: .alwaysOriginal),
            selectedImage: UIImage(systemName: selectedTabBarImage)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
}
