//
//  PostSession.swift
//  PlayStop
//
//  Created by mathusan selvakumar on 22/09/2022.
//

import Foundation

struct PostSession: Codable {
    
    let clientID: String
    let authorization: String
    
    enum CodingKeys: String, CodingKey {
        case clientID = "Client-ID"
        case authorization = "Authorization"
    }
}
