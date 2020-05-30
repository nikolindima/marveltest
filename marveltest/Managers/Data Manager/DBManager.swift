//
//  DBManager.swift
//  marveltest
//
//  Created by Dmitriy Nikolin on 29/05/2020.
//  Copyright © 2020 dnikolin. All rights reserved.
//

import UIKit
import RealmSwift

class DBManager {
    
    // MARK: - Properties
    private var database: Realm
    static let sharedInstance = DBManager()
    let results: Results<CharacterRealm>
    
    
    // MARK: - Init
    private init() {
        let config = Realm.Configuration(objectTypes: [CharacterRealm.self])
        database = try! Realm(configuration: config)
        
        results = database.objects(CharacterRealm.self).sorted(byKeyPath: "date", ascending: false)
      }
    
    // MARK: - DP methods
    func getDataFromDB() -> Results<CharacterRealm> {
        return results
    }
    func addData(object: CharacterRealm) {
        try! database.write {
            database.add(object, update: .all)
        }
    }
    func deleteAllFromDatabase()  {
        try!   database.write {
            database.deleteAll()
        }
    }
    func deleteFromDb(object: CharacterRealm)   {
        try!   database.write {
            database.delete(object)
        }
    }
}
