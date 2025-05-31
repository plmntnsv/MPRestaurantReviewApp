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
        
        view.backgroundColor = UIColor.screenBG
        navigationController?.navigationBar.tintColor = UIColor.screenFG
        
        navigationItem.standardAppearance = navAppearance
        navigationItem.scrollEdgeAppearance = navAppearance
        navigationItem.compactAppearance = navAppearance
        navigationItem.compactScrollEdgeAppearance = navAppearance
        
//        navigationController?.navigationBar.standardAppearance = navAppearance
//        navigationController?.navigationBar.compactAppearance = navAppearance
//        
//        navigationItem.standardAppearance?.buttonAppearance = navButtonAppearance
//        navigationItem.compactAppearance?.buttonAppearance = navButtonAppearance
//        navigationItem.standardAppearance?.doneButtonAppearance = navButtonAppearance
//        navigationItem.compactAppearance?.doneButtonAppearance = navButtonAppearance
//        navigationItem.standardAppearance?.backButtonAppearance = navButtonAppearance
//        navigationItem.compactAppearance?.backButtonAppearance = navButtonAppearance
    }
}
