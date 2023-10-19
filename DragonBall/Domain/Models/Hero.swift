//
//  Hero.swift
//  DragonBall
//
//  Created by Manuel Cazalla Colmenero on 18/10/23.
//

import Foundation

typealias Heroes = [Hero]

struct Hero: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case photo
        case isfavorite = "favorite"
    }
    
    let id: String?
    let name: String?
    let description: String?
    let photo: String?
    let isfavorite: Bool?
}
