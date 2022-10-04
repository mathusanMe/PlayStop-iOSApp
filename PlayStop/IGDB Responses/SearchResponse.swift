//
//  SearchResponse.swift
//  PlayStop
//
//  Created by mathusan selvakumar on 22/09/2022.
//

import Foundation

struct SearchResponse: Codable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
}
