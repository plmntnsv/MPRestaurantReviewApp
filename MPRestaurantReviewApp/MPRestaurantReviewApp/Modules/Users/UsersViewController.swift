//
//  UsersViewController.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 31.05.25.
//

import Foundation
import UIKit

final class UsersViewController: BaseAppearanceViewController {
    @IBOutlet private weak var usersTableView: UITableView!
    @IBOutlet weak var noUsersFoundLabel: UILabel!
    private let searchBar = UISearchBar()
    
    var viewModel: UsersViewModel!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupTableView()
    }
    
    // MARK: Private
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.searchTextField.backgroundColor = .white.withAlphaComponent(0.8)
        let clearImg = UIImage(systemName: "xmark.circle")!.withTintColor(.lightGray).withRenderingMode(.alwaysOriginal)
        searchBar.setImage(clearImg, for: .clear, state: .normal)
        searchBar.placeholder = "Search for users by email..."
        searchBar.showsCancelButton = true
        
        navigationItem.titleView = searchBar
    }

    private func setupTableView() {
        usersTableView.dataSource = self
        usersTableView.register(
            UINib(nibName: "\(UserCell.self)", bundle: nil),
            forCellReuseIdentifier: "\(UserCell.self)"
        )
    }

    private func performSearch(with text: String) {
        Task {
            switch await viewModel.searchForUser(with: text) {
            case .success(let foundUsers):
                usersTableView.reloadData()
                if !foundUsers {
                    noUsersFoundLabel.isHidden = false
                }
            case .failure(let error):
                ErrorHandler.showError(error, in: self)
            }
        }
    }
}

// MARK: - UISearchBarDelegate
extension UsersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        noUsersFoundLabel.isHidden = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let text = searchBar.text else { return }
        
        performSearch(with: text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        noUsersFoundLabel.isHidden = true
        searchBar.text = ""
        searchBar.resignFirstResponder()
        viewModel.clearResult()
        usersTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension UsersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.searchResult.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = usersTableView.dequeueReusableCell(
            withIdentifier: "\(UserCell.self)"
        ) as! UserCell
        
        cell.selectionStyle = .none
        cell.setup(with: viewModel.searchResult[indexPath.row], delegate: self)
        
        return cell
    }
}

// MARK: - UserCellDelegate
extension UsersViewController: UserCellDelegate {
    func userCell(_ cell: UserCell, didTapMakeAdminFor user: User) {
        Task {
            switch await viewModel.makeUserAdmin(user) {
            case .success:
                usersTableView.reloadData()
            case .failure(let error):
                ErrorHandler.showError(error, in: self)
            }
        }
    }
    
    func userCell(_ cell: UserCell, didTapDeleteFor user: User) {
        Task {
            switch await viewModel.deleteUser(user) {
            case .success:
                searchBarCancelButtonClicked(searchBar)
            case .failure(let error):
                ErrorHandler.showError(error, in: self)
            }
        }
        
    }
}
