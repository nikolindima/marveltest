//
//  CharacterTableViewCellModel.swift
//  marveltest
//
//  Created by Dmitriy Nikolin on 29/05/2020.
//  Copyright © 2020 dnikolin. All rights reserved.
//

import UIKit

struct HistoryCharacterTableViewCellModel {
    
    // MARK: - Properties
    
    let character: CharacterRealm
    
    var name: String {
        return character.name
    }
    
    var description: String {
        return character.desc
    }
    
    var image: URL? {
        return URL(string: character.thumbnail)
    }
    
}
