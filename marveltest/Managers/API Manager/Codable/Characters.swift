//
//  Characters.swift
//  marveltest
//
//  Created by Dmitriy Nikolin on 28/05/2020.
//  Copyright © 2020 dnikolin. All rights reserved.
//

import Foundation

struct CharacterDataWrapper: Codable {
    var code: Int?
    var status: String?
    var data: CharacterDataContainer?
}

struct CharacterDataContainer: Codable {
    var offset: Int?
    var total: Int?
    var count: Int?
    var results: [Character]?
}

struct Character: Codable {
    var id: Int?
    var name: String?
    var description: String?
    var thumbnail: Thumbnail?
}

struct Thumbnail: Codable {
    var path: String?
    var `extension`: String?
}
