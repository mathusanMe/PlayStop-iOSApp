//
//  test.swift
//  PlayStop
//
//  Created by mathusan selvakumar on 21/09/2022.
//

import Foundation
import IGDB_SWIFT_API

class IGDBClient {
    
    static let clientID = "vdzvenhr844u11k08uan0e47que9sb"
    static let clientSecret = "1r8i7zqtbv9u02oifbaazfnd1wycf3"
    static let grantType = "client_credentials"
    static var wrapper: IGDBWrapper = IGDBWrapper(clientID: clientID, accessToken: Auth.accessToken)
    
    struct Auth {
        static var accessToken = ""
        static var expiresIn = 0
        static var tokenType = ""
    }
    
    enum Endpoints {
        static let base = "https://api.igdb.com/v4"
        static let oauth2Base = "https://id.twitch.tv/oauth2/token"
        static let clientIDParam = "?client_id=\(IGDBClient.clientID)"
        static let clientSecretParam = "&client_secret=\(IGDBClient.clientSecret)"
        
        case getAuthentification
        
        var stringValue: String {
            switch self {
            case .getAuthentification:
                return Endpoints.oauth2Base
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    class func postAuthentification(completion: @escaping (Bool, Error?) -> Void) {
        let body = AuthentificationRequest(clientID: clientID, clientSecret: clientSecret, grantType: grantType)
        taskForPOSTRequest(url: Endpoints.getAuthentification.url, responseType: AuthentificationResponse.self, body: body) { response, error in
            if let response = response {
                Auth.accessToken = response.accessToken
                Auth.expiresIn = response.expiresIn
                Auth.tokenType = response.tokenType.capitalizingFirstLetter()
                
                wrapper = IGDBWrapper(clientID: clientID, accessToken: Auth.accessToken)
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
