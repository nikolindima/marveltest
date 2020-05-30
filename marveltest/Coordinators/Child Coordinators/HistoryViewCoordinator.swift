//
//  HistoryViewCoordinator.swift
//  marveltest
//
//  Created by Dmitriy Nikolin on 27/05/2020.
//  Copyright © 2020 dnikolin. All rights reserved.

import Foundation
import UIKit

class HistoryViewCoordinator: Coordinator {
    
     private let navigationController : UINavigationController
       
       var rootViewController : UIViewController {
           return navigationController
       }
       private let historyViewController  = HistoryViewController.instantiate()
       
       // MARK: - Init
       override init() {
           navigationController = UINavigationController(rootViewController: historyViewController)
           super.init()
       }
       
       
       override func start() {
           
           let historyViewModel = HistoryViewViewModel()
           
           historyViewController.viewModel = historyViewModel
           
           historyViewModel.setupModel()
           
           historyViewModel.loadDetailedView = {char in
               let detailedViewModel = DetailedViewViewModel(character: char)
               
               let detailedViewController = DetailedViewController.instantiate()
               detailedViewController.viewModel = detailedViewModel
               
               self.navigationController.pushViewController(detailedViewController, animated: true)
           }
           
       }
    
}
