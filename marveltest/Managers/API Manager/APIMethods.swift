//
//  APIMethods.swift
//  marveltest
//
//  Created by Dmitriy Nikolin on 27/05/2020.
//  Copyright © 2020 dnikolin. All rights reserved.
//

import Alamofire

enum MarverlMethods {
    
    // MARK: API Methods
    case character
    case characterWithID(_: String)
    
}

extension MarverlMethods: EndPointType {
    
    // MARK: - Properties
    
    var baseURL: String {
        return Config.baseURL
    }
    
    var path: String {
        switch self {
        case .character:
            return "/characters"
        case .characterWithID(let characterId):
            return "/characters/\(characterId)"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var headers: HTTPHeaders? {
        return ["Content-Type": "application/json; charset=utf-8"]
    }
    
    var url: URL {
        switch self {
        default:
            return URL(string: self.baseURL + self.path)!
        }
    }
   
    
}
