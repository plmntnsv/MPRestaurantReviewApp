//
//  UserCell.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 4.06.25.
//

import Foundation
import UIKit

protocol UserCellDelegate:AnyObject {
    func userCell(_ cell: UserCell, didTapMakeAdminFor user: User)
    func userCell(_ cell: UserCell, didTapDeleteFor user: User)
}

final class UserCell: UITableViewCell {
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    
    private var user: User?
    private weak var delegate: UserCellDelegate?
    
    func setup(with user: User, delegate: UserCellDelegate) {
        emailLabel.text = user.email
        firstNameLabel.text = user.firstName
        lastNameLabel.text = user.lastName
        roleLabel.text = user.role
        self.user = user
        self.delegate = delegate
    }
    
    @IBAction func didTapMakeAdminButton(_ sender: Any) {
        guard let user else { return }
        delegate?.userCell(self, didTapMakeAdminFor: user)
    }
    
    @IBAction func didTapDeleteButton(_ sender: Any) {
        guard let user else { return }
        delegate?.userCell(self, didTapDeleteFor: user)
    }
}
