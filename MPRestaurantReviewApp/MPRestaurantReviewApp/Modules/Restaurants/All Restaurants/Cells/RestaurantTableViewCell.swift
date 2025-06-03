//
//  RestaurantTableViewCell.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 1.06.25.
//

import Foundation
import UIKit

protocol RestaurantTableViewCellDelegate: AnyObject {
    func restaurantCellDidTapEdit(_ restaurant: Restaurant)
    func restaurantCellDidTapDelete(_ restaurant: Restaurant)
}

final class RestaurantTableViewCell: UITableViewCell {
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var actionButtonsStackView: UIStackView?
    @IBOutlet weak var titleLabel: UILabel!
    
    private weak var delegate: RestaurantTableViewCellDelegate?
    private var restaurant: Restaurant?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if !UserManager.shared.currentUser!.isAdmin {
            actionButtonsStackView?.removeFromSuperview()
        }
    }
    
    func setup(with restaurant: Restaurant, delegate: RestaurantTableViewCellDelegate) {
        self.restaurant = restaurant
        self.delegate = delegate
        titleLabel.text = "\(restaurant.name)"
        ratingLabel.text = "\(restaurant.averageRating.asRating)"
    }
    
    @IBAction private func didTapEditButton(_ sender: Any) {
        guard let delegate, let restaurant else { return }
        delegate.restaurantCellDidTapEdit(restaurant)
    }
    
    @IBAction private func didTapDeleteButton(_ sender: Any) {
        guard let delegate, let restaurant else { return }
        delegate.restaurantCellDidTapDelete(restaurant)
    }
}
