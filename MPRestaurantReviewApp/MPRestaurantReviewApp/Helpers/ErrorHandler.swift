//
//  ErrorHandler.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 31.05.25.
//

import UIKit

enum AppError: LocalizedError {
    case userNotFound
    case badInput(additionalInfo: String? = nil)
    case decodingError
    case networkFetchError
    case unknown
    
    var error: NSError {
        NSError(
            domain: domain,
            code: code,
            userInfo: [NSLocalizedDescriptionKey: errorDescription]
        )
    }
    
    var domain: String {
        switch self {
        case .userNotFound:
            "AuthErrorDomain"
        case .badInput:
            "BadInputDomain"
        case .decodingError:
            "DecodingErrorDomain"
        case .networkFetchError:
            "NetworkErrorDomain"
        case .unknown:
            "GenericErrorDomain"
        }
    }
    
    var code: Int {
        switch self {
        case .userNotFound:
            1000
        case .badInput:
            1001
        case .decodingError:
            1002
        case .networkFetchError:
            1003
        case .unknown:
            1999
        }
    }
    
    var errorDescription: String {
        switch self {
        case .userNotFound:
            "User does not exist"
        case .badInput(let additionalInfo):
            "Invalid input.\n\(additionalInfo ?? "")"
        case .decodingError:
            "Failed to decode data"
        case .networkFetchError:
            "Something went wrong while fetching data"
        case .unknown:
            "Something went wrong"
        }
    }
}

final class ErrorHandler {
    static func showError(_ error: Error, in viewController: UIViewController) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Error",
                message: error.localizedDescription,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            viewController.present(alert, animated: true)
        }
    }
}

