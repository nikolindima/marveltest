//
//  SearchViewCoordinator.swift
//  marveltest
//
//  Created by Dmitriy Nikolin on 27/05/2020.
//  Copyright © 2020 dnikolin. All rights reserved.

import Foundation
import UIKit

class SearchViewCoordinator: Coordinator {
    
    // MARK: - Properties
    private let navigationController : UINavigationController
    
    var rootViewController : UIViewController {
        return navigationController
    }
    private let searchViewController  = SearchViewController.instantiate()
    
    // MARK: - Init
    override init() {
        navigationController = UINavigationController(rootViewController: searchViewController)
        super.init()
    }
    
    
    override func start() {
        
        let searchViewModel = SearchViewModel()
        
        searchViewController.viewModel = searchViewModel
        
        searchViewModel.loadDetailedView = {char in
            let detailedViewModel = DetailedViewViewModel(character: char)
            
            let detailedViewController = DetailedViewController.instantiate()
            detailedViewController.viewModel = detailedViewModel
            
            self.navigationController.pushViewController(detailedViewController, animated: true)
        }
        
       
        
    }
    
}
