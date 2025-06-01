//
//  Coordinator.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 29.05.25.
//

class Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: Coordinator?
    
    func start() {
        preconditionFailure("start(animated:) must be overriden by subclass!")
    }
    
    func finish() {
        parentCoordinator?.removeChildCoordinator(self)
    }
    
    @discardableResult
    func addChildCoordinator(_ coordinator: Coordinator) -> Bool {
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        
        return true
    }
    
    @discardableResult
    func removeChildCoordinator(_ coordinator: Coordinator) -> Bool {
        guard let index = childCoordinators.firstIndex(of: coordinator) else {
            return false
        }
            
        childCoordinators.remove(at: index)
        return true
    }
    
    func removeAllChildCoordinators() {
        childCoordinators.removeAll()
    }
}

extension Coordinator: Equatable {
    static func == (lhs: Coordinator, rhs: Coordinator) -> Bool {
        return lhs === rhs
    }
}

extension Coordinator {
    func firstParent<T: Coordinator>(of type: T.Type) -> T? {
        if let parentOfType = parentCoordinator as? T {
            return parentOfType
        }
        return parentCoordinator?.firstParent(of: type)
    }
    
    // AppCoordinator must be the first Coordinator of the coordinators' chain
    // We ! unwrap it because if it is missing something is totally wrong
    // and we better crash.
    var appCoordinator: AppCoordinator! {
        return firstParent(of: AppCoordinator.self)
    }
}

