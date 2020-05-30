//
//  CharacterTableViewCellModel.swift
//  marveltest
//
//  Created by Dmitriy Nikolin on 29/05/2020.
//  Copyright © 2020 dnikolin. All rights reserved.
//

import UIKit

struct CharacterTableViewCellModel {
    
    // MARK: - Properties
    
    let character: Character
    
    var name: String {
        return character.name ?? ""
    }
    
    var description: String {
        return character.description ?? ""
    }
    
    var image: URL? {
        guard var url = character.thumbnail?.path, let extention = character.thumbnail?.extension else {
            return nil
        }
        url = url + "/standard_xlarge." + extention
        return URL(string: url)
    }
    
}
