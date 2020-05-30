//
//  HistoryViewViewModel.swift
//  marveltest
//
//  Created by Dmitriy Nikolin on 29/05/2020.
//  Copyright © 2020 dnikolin. All rights reserved.
//

import UIKit
import RealmSwift

class HistoryViewViewModel {
    
    // MARK: - Properties
    var notificationToken: NotificationToken? = nil
    
    // MARK: - Injectinos
    var updateUI:(()->())?
    var loadDetailedView:((CharacterRealm)->())?
    
    // MARK: - SetupMode
    func setupModel() {
        notificationToken = DBManager.sharedInstance.results.observe { [weak self] (changes: RealmCollectionChange) in
            self?.updateUI?()
            
        }
    }
    
    // MARK: - TableView Helpers
    
    var numberOfRows: Int {
        return DBManager.sharedInstance.getDataFromDB().count
    }
    
    func cellViewModelForIndex(indexPath : IndexPath) -> HistoryCharacterTableViewCellModel {
        let char = DBManager.sharedInstance.getDataFromDB()[indexPath.row] as CharacterRealm
        let cellModel = HistoryCharacterTableViewCellModel(character: char)
        
        return cellModel
    }
    func selectedTableRow(indexPath: IndexPath) {
        let char = DBManager.sharedInstance.getDataFromDB()[indexPath.row] as CharacterRealm
        self.loadDetailedView?(char)
    }
    
    // MARK: - deinit
   deinit {
       notificationToken?.invalidate()
   }
    
}
