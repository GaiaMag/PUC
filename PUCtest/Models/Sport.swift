//
//  Sport.swift
//  PUCtest
//
//  Created by MAGNANIG-NB on 04/11/2018.
//  Copyright © 2018 MAGNANIG-NB. All rights reserved.
//

import UIKit

struct Response: Decodable {
    let code: Int
    let descriprion: String
    
    enum CodingKeys: String, CodingKey {
        case code
        case descriprion
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decode(Int.self, forKey: CodingKeys.code)
        self.descriprion = try container.decode(String.self, forKey: CodingKeys.descriprion)
    }
}


struct ResponseSport: Decodable {
    let data: SportsAPI
    
    enum CodingKeys: String, CodingKey {
        case data
        case status
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decode(SportsAPI.self, forKey: CodingKeys.data)
    }
}

struct SportsAPI: Decodable {
    let list: [Sport]
    
    enum DataKeys: String, CodingKey {
        case total
        case items_per_page
        case list
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DataKeys.self)
        self.list = try container.decode([Sport].self, forKey: DataKeys.list)
    }
}

struct Sport: Decodable {
    let id: Int
    let name: String
    let matchDuration: Int
    let timeDuration: Int
    let numberOfTimes: Int
    let icon: String
    
    enum CodingKeys : String, CodingKey {
        case id
        case name
        case match_duration
        case time_duration
        case number_of_times
        case icon
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: Sport.CodingKeys.id)
        self.name = try container.decode(String.self, forKey: Sport.CodingKeys.name)
        self.matchDuration = try container.decode(Int.self, forKey: Sport.CodingKeys.match_duration)
        self.timeDuration = try container.decode(Int.self, forKey: Sport.CodingKeys.time_duration)
        self.numberOfTimes = try container.decode(Int.self, forKey: Sport.CodingKeys.number_of_times)
        self.icon = try container.decode(String.self, forKey: Sport.CodingKeys.icon)
    }
}


