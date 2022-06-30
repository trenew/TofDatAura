//
//  User.swift
//  TofDatAura
//
//  Created by User on 30/06/2022.
//

import Foundation

struct User: Codable, Identifiable {
    let id: String?
    let username: String
    let name: String?
    let location: String?
    let large: String?
    
    init (from username: String) {
        id = nil
        name = nil
        self.username = username
        location = nil
        large = nil
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        username = try values.decode(String.self, forKey: .username)
        name = try values.decode(String.self, forKey: .name)
        let profile_image = try values.nestedContainer(keyedBy: UrlsKeys.self, forKey: .profile_image)
        large = try profile_image.decode(String.self, forKey: .large)
        do {
            location = try values.decode(String.self, forKey: .location)
        } catch {
            location = nil
        }
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case name
        case location
        case profile_image
    }
    
    enum UrlsKeys: String, CodingKey {
        case large
    }
}
