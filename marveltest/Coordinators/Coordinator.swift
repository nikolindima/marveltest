//
//  Coordinator.swift
//  marveltest
//
//  Created by Dmitriy Nikolin on 27/05/2020.
//  Copyright © 2020 dnikolin. All rights reserved.
//

import UIKit

class Coordinator: NSObject, UINavigationControllerDelegate {
    
    // MARK: - Properties
    var hideTabBar : ((Bool) -> ())?
    var didFinish: ((Coordinator) -> Void)?
    
    // MARK: -
    var presentView: ((UIViewController, (()->())?) -> ())?
    var presentViewDetails: ((UIViewController, (()->())?) -> ())?
    var showSettingsViewController: (()->())?
    
    // MARK: -
    var childCoordinators: [Coordinator] = []

    // MARK: - Methods
    
    func start() {}
    
    // MARK: -
    func pushCoordinator(_ coordinator: Coordinator) {
        // Install Handler
        coordinator.didFinish = { [weak self] (coordinator) in
            self?.popCoordinator(coordinator)
        }
        
        // Start Coordinator
        coordinator.start()
        
        // Append to Child Coordinators
        childCoordinators.append(coordinator)
    }
    
    func popCoordinator(_ coordinator: Coordinator) {
        // Remove Coordinator From Child Coordinators
        if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        }
    }
  
}
