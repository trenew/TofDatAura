//
//  PhotoDetailed.swift
//  TofDatAura
//
//  Created by User on 01/07/2022.
//

import Foundation
import CoreLocation

struct PhotoDetailed: Codable, Identifiable, PhotoBase {
    let id: String
    let color: String?
    let user: User?
    let name: String?
    let raw: String?
    let thumb: String?
    let created_at: Date?
    let downloads: Int?
    let likes: Int
    let width: Int
    let height: Int
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case color
        case user
        case urls
        case created_at
        case downloads
        case likes
        case width
        case height
        case description
    }
    
    enum UrlsKeys: String, CodingKey {
        case raw
        case thumb
        case likes
        case width
        case height
        case description
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: PhotoDetailed.CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        color = try values.decode(String.self, forKey: .color)
        user = try values.decode(User.self, forKey: .user)
        let time = try values.decode(String.self, forKey: .created_at)
        created_at = DateFormatter.parseTime(time: time)
        do {
            downloads = try values.decode(Int.self, forKey: .downloads)
        } catch {
            downloads = nil
        }
        let urls = try values.nestedContainer(keyedBy: UrlsKeys.self, forKey: .urls)
        raw = try urls.decode(String.self, forKey: .raw)
        thumb = try urls.decode(String.self, forKey: .thumb)
        likes = try values.decode(Int.self, forKey: .likes)
        name = user?.name
        width = try values.decode(Int.self, forKey: .width)
        height = try values.decode(Int.self, forKey: .height)
        do {
            description = try values.decode(String.self, forKey: .description)
        } catch {
            description = nil
        }
    }
    
    init(id: String,
         color: String?,
         user: User?,
         name: String?,
         raw: String?,
         thumb: String?,
         created_at: Date?,
         downloads: Int?,
         likes: Int,
         width: Int,
         height: Int,
         description: String?) {
        self.id = id
        self.color = color
        self.user =  user
        self.raw = raw
        self.thumb = thumb
        self.created_at = created_at
        self.name = name
        self.likes = likes
        self.width = width
        self.height = height
        self.description = description
        self.downloads = downloads
    }
    
    init() {
        id =  ""
        color = nil
        user = nil
        name = nil
        created_at = nil
        downloads = nil
        raw = nil
        thumb = nil
        likes = 0
        width = 0
        height = 0
        description = nil
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
}
