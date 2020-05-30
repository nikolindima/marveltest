//
//  CharacterRealm.swift
//  marveltest
//
//  Created by Dmitriy Nikolin on 29/05/2020.
//  Copyright © 2020 dnikolin. All rights reserved.
//


import RealmSwift

class CharacterRealm: Object {
    @objc dynamic var date = Date()
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var desc = ""
    @objc dynamic var thumbnail = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
