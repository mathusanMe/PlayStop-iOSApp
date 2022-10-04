//
//  AuthentificationRequest.swift
//  PlayStop
//
//  Created by mathusan selvakumar on 22/09/2022.
//

import Foundation

struct AuthentificationRequest: Codable {
    
    let clientID: String
    let clientSecret: String
    let grantType: String
    
    enum CodingKeys: String, CodingKey {
        case clientID = "client_id"
        case clientSecret = "client_secret"
        case grantType = "grant_type"
    }
}
