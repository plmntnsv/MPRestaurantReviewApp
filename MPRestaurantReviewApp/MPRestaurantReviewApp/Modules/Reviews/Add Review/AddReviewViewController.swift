//
//  AddReviewViewController.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 2.06.25.
//

import Foundation
import UIKit

protocol AddReviewViewControllerDelegate: AnyObject {
    func onReviewAddedToRestaurant(review: Review, to restaurant: Restaurant)
}

final class AddReviewViewController: KeyboardResponsiveViewController {
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var rateResultLabel: UILabel!
    @IBOutlet private weak var rateSlider: UISlider!
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var commentTextView: UITextView!
    
    var viewModel: AddReviewViewModel!
    weak var delegate: AddReviewViewControllerDelegate?
    
    override var contentScrollView: UIScrollView? { scrollView }
    override var screenOffsetOnKeyboardAppear: CGFloat { 50 }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = viewModel.restaurant.name
        commentTextView.delegate = self
        commentTextView.layer.cornerRadius = 8
        rateSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    }

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
        
        Task {
            switch await viewModel.didTapAdd(rating: rating, comment: comment, visitDate: datePicker.date) {
            case .success(let review):
                delegate?.onReviewAddedToRestaurant(review: review, to: viewModel.restaurant)
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
    }
}

extension AddReviewViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars <= 500
    }
}
