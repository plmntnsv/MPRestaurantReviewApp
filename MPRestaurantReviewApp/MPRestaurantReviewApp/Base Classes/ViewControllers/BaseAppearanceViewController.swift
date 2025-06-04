//
//  BaseAppearanceViewController.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 30.05.25.
//

import Foundation
import UIKit

class BaseAppearanceViewController: UIViewController {
    private var navAppearance: UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.clear
        appearance.titleTextAttributes = [.foregroundColor: UIColor.screenFG]
        appearance.backgroundImage = nil
        
        return appearance
    }
    
    private var navButtonAppearance: UIBarButtonItemAppearance {
        let appearance = UIBarButtonItemAppearance()
        appearance.normal.titleTextAttributes = [.foregroundColor: UIColor.screenFG]
        
        return appearance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.backgroundColor2
        navigationController?.navigationBar.tintColor = UIColor.screenFG
        
        navigationItem.standardAppearance = navAppearance
        navigationItem.scrollEdgeAppearance = navAppearance
        navigationItem.compactAppearance = navAppearance
        navigationItem.compactScrollEdgeAppearance = navAppearance
    }
}
