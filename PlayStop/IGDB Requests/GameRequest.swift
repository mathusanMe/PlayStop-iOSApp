//
//  GameRequest.swift
//  PlayStop
//
//  Created by mathusan selvakumar on 02/10/2022.
//

import Foundation

struct GameRequest: Codable {
    
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
    }
}
