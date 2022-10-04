//
//  AuthentificationResponse.swift
//  PlayStop
//
//  Created by mathusan selvakumar on 21/09/2022.
//

import Foundation

struct AuthentificationResponse: Codable {
    
    let accessToken: String
    let expiresIn: Int
    let tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
    }
}
