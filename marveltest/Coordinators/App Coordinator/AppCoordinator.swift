//
//  AppCoordinator.swift
//  marveltest
//
//  Created by Dmitriy Nikolin on 27/05/2020.
//  Copyright © 2020 dnikolin. All rights reserved.
//

import UIKit

class AppCoordinator : Coordinator{
    
    // MARK: - Properties
    let rootViewController: RootViewController = RootViewController.instantiate()
    
    let searchViewCoordinator = SearchViewCoordinator()
    let historyViewCoordinator = HistoryViewCoordinator()
    
    
    // MARK: - Initialization
    override init() {
        super.init()
        self.childCoordinators.append(self.searchViewCoordinator)
        self.childCoordinators.append(self.historyViewCoordinator)
              
    }
    
    // MARK: - Methods
    override func start() {
        
      
        rootViewController.viewControllers = [searchViewCoordinator.rootViewController, historyViewCoordinator.rootViewController]
        for coordinator in childCoordinators {
            coordinator.start()
            
        }
        rootViewController.selectedIndex = 0
        
        
        
    }
    
    
}
