//
//  APIManager.swift
//  marveltest
//
//  Created by Dmitriy Nikolin on 27/05/2020.
//  Copyright © 2020 dnikolin. All rights reserved.
//

import Alamofire
import CryptoSwift


enum APIManagerError: Error {
    case unknown
    case noInternet
    case failedRequest
    case invalidResponse
}

class APIManager {
    
    // MARK: - Properties
    private let sessionManager: Session
    
    private static var sharedApiManager: APIManager = {
        let apiManager = APIManager(sessionManager: Session())
        
        return apiManager
    }()
    
    // MARK: - Accessors
    
    class func shared() -> APIManager {
        return sharedApiManager
    }
    
    
    // MARK: - Init
    private init(sessionManager: Session) {
        self.sessionManager = sessionManager
    }
    
    // MARK: - API Call
    private func call<T>(type: EndPointType,params: Parameters? = nil, handler: @escaping (T?, _ error: APIManagerError?)->()) where T: Codable {
        
        let ts = "\(Date().timeIntervalSince1970)"
        let hash = "\(ts)\(Config.Privatekey)\(Config.APIKey)".md5()
        var parametrs : Parameters = ["ts" : ts, "apikey" : Config.APIKey, "hash" : hash]
        
        if let params = params {
            parametrs.merge(params, uniquingKeysWith: { (current, _) in current })
        }
        
        self.sessionManager.request(type.url,
                                    method: type.httpMethod,
                                    parameters: parametrs,
                                    headers: type.headers).validate().responseJSON { data in
                                        switch data.result {
                                        case .success(_):
                                            let decoder = JSONDecoder()
                                            if let jsonData = data.data {
                                                do {
                                                    let result = try decoder.decode(T.self, from: jsonData)
                                                    handler(result, nil)
                                                } catch  {
                                                    handler(nil, .invalidResponse)
                                                }
                                            }
                                        case .failure(let encodingError):
                                            if encodingError.isSessionTaskError {
                                                handler(nil, .noInternet)
                                            }
                                            else {
                                                handler(nil, .unknown)
                                            }
                                        }
        }
        
        
        
        
    }
    // MARK: - API Methosds
    func searchCharacter(name: String, params: Parameters? = nil, handler: @escaping (_ characters : [Character]?, _ error: APIManagerError?, _ haveMore: Bool)->()) {
        
        self.sessionManager.cancelAllRequests()
        self.call(type: MarverlMethods.character, params: params) { (characters: CharacterDataWrapper?, message: APIManagerError?) in
            if let char = characters {
                guard let charsData = char.data else {
                    handler(nil, message, false)
                    return
                }
                let total = charsData.total ?? 0
                let count = charsData.count ?? 0
                let offset = charsData.offset ?? 0
                var haveMore = false
                
                if total > offset+count {
                    haveMore = true
                }
                
                handler(charsData.results, nil, haveMore)
            } else {
                handler(nil, message, false)
            }
        }
    }
    
    
}
