//
//  AddReviewViewController.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 2.06.25.
//

import Foundation
import UIKit

final class AddReviewViewController: KeyboardResponsiveViewController {
    enum ScreenType {
        case add
        case edit(_ review: Review)
    }
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var rateResultLabel: UILabel!
    @IBOutlet private weak var rateSlider: UISlider!
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var commentTextView: UITextView!
    @IBOutlet private weak var addButton: PrimaryButton!
    
    var viewModel: AddReviewViewModel!
    var screenType: ScreenType = .add
    
    override var contentScrollView: UIScrollView? { scrollView }
    override var screenOffsetOnKeyboardAppear: CGFloat { 50 }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        rateSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    }
    
    // MARK: - Private
    @objc private func sliderValueChanged(_ sender: UISlider) {
        let roundedValue = round(sender.value * 10) / 10.0
        rateResultLabel.text = String(format: "%.1f", roundedValue)
    }
    
    @IBAction private func addReviewButtonTapped(_ sender: Any) {
        guard let ratingAsString = rateResultLabel.text,
              let rating = Double(ratingAsString),
              let comment = commentTextView.text,
              !comment.isEmpty else {
            ErrorHandler.showError(AppError.badInput(additionalInfo: nil).error, in: self)
            return
        }
        
        let blockedView = view.block()
        
        switch screenType {
        case .add:
            Task {
                switch await viewModel.addReview(rating: rating, comment: comment, visitDate: datePicker.date) {
                case .success(let review):
                    NotificationCenter.default.post(
                        name: .reviewAdded,
                        object: nil,
                        userInfo: [
                            NotificationUserInfoKey.review: review,
                            NotificationUserInfoKey.restaurant: viewModel.restaurant
                        ]
                    )
                    let alert = UIAlertController(title: "Success", message: "Review added!", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                        self?.viewModel.finishAddingReview()
                    }
                    alert.addAction(okAction)
                    present(alert, animated: true)
                    
                    break
                case .failure(let error):
                    blockedView.removeFromSuperview()
                    ErrorHandler.showError(error, in: self)
                }
            }
        case .edit(let review):
            Task {
                var editedReview = review
                editedReview.rating = rating
                editedReview.comment = comment
                editedReview.visitDate = datePicker.date
                
                switch await viewModel.editReview(editedReview) {
                case .success:
                    NotificationCenter.default.post(
                        name: .reviewEdited,
                        object: nil,
                        userInfo: [
                            NotificationUserInfoKey.review: editedReview,
                            NotificationUserInfoKey.restaurant: viewModel.restaurant
                        ]
                    )
                    viewModel.finishAddingReview()
                case .failure(let error):
                    ErrorHandler.showError(error, in: self)
                }
                blockedView.removeFromSuperview()
            }
        }
    }
    
    private func setupUI() {
        navigationItem.title = viewModel.restaurant.name
        navigationItem.backButtonTitle = "Back"
        
        commentTextView.delegate = self
        commentTextView.layer.cornerRadius = 8
        
        switch screenType {
        case .add:
            break
        case .edit(let review):
            addButton.setTitle("Save", for: .normal)
            commentTextView.text = review.comment
            datePicker.setDate(review.visitDate, animated: false)
            rateSlider.value = Float(review.rating)
        }
    }
}

// MARK: - UITextViewDelegate
extension AddReviewViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars <= 500
    }
}
