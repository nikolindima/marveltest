//
//  SearchViewModel.swift
//  marveltest
//
//  Created by Dmitriy Nikolin on 27/05/2020.
//  Copyright © 2020 dnikolin. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa


class SearchViewModel {
    
    // MARK: - Properties
    
    let disposeBag = DisposeBag()
    let characters: BehaviorRelay<[Character]> = BehaviorRelay(value: [])
    var selectedCharacter : Character?
    
    // MARK: -
    var isLoading = false
    var haveMore = false
    var offset = 0
    var lastSearchString = ""
    
    // MARK: - Injections
    var updateUI:(()->())?
    var updateDetailedView:(()->())?
    var loadDetailedView:((CharacterRealm)->())?
    var showAlert:((String)->())?
    
    // MARK: - Search
    func searchCharacters(with name: String) {
        if name.count == 0 {
            offset = 0
            characters.accept([])
            self.updateUI?()
            return
        }
        if lastSearchString != name {
            offset = 0
        }
        lastSearchString = name
        isLoading = true
        self.updateUI?()
        let params : Parameters = ["limit" :  Config.loadRowCount, "offset" : offset, "nameStartsWith" : name]
        APIManager.shared().searchCharacter(name: name, params: params) { (characters, alert, haveMore) in
            self.haveMore = haveMore
            self.isLoading = false
            
            if let characs = characters {
                if self.offset > 0 {
                    self.characters.accept(self.characters.value + characs)
                }
                else {
                    self.characters.accept(characs)
                }
                
            }
            else {
                guard let alert = alert else { return }
                var message = ""
                switch alert {
                case .failedRequest:
                    message = "Request Faild"
                case .invalidResponse, .unknown:
                    message = "Please try again later"
                case .noInternet:
                    message = "Please check your internet connections"
                }
                self.showAlert?(message)
                
            }
            
            self.updateUI?()
        }
    }
    // MARK: - LoadMore
    func loadmore() {
        
        if isLoading == false && haveMore == true {
            offset += Config.loadRowCount
            self.searchCharacters(with: lastSearchString)
        }
    }
    
    // MARK: - Table Helpers
    var numberOfRows: Int {
        if isLoading {
            return characters.value.count + 1
        }
        return characters.value.count
    }
    
    func characterForIndexPath(indexPath:IndexPath) -> Character? {
        if indexPath.row == characters.value.count {
            return nil
        }
        return characters.value[indexPath.row]
    }
    
    func selectedTableRow(indexPath: IndexPath) {
        
        if indexPath.row == characters.value.count {
            return
        }
        let char = characters.value[indexPath.row]
        selectedCharacter = char
        
        self.updateDetailedView?()
        
        let saveChar = CharacterRealm()
        saveChar.id = char.id ?? 0
        saveChar.name = detailedViewName
        saveChar.desc = detailedDescription
        saveChar.thumbnail = detailedCharacterImage.absoluteString
        DBManager.sharedInstance.addData(object: saveChar)
        
        if UIDevice.current.orientation != .landscapeLeft && UIDevice.current.orientation != .landscapeRight{
            self.loadDetailedView?(saveChar)
        }
    }
    
    // MARK: - DetailedView Helpers
    var detailedViewName : String {
        return selectedCharacter?.name ?? ""
    }
    
    var detailedDescription: String {
        return selectedCharacter?.description ?? ""
    }
    
    var detailedCharacterImage: URL {
        guard var url = selectedCharacter?.thumbnail?.path, let extention = selectedCharacter?.thumbnail?.extension else {
            return URL(string: "")!
        }
        url = url + "/detail." + extention
        return URL(string: url)!
    }
    
}
