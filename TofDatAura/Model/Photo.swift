//
//  Photo.swift
//  TofDatAura
//
//  Created by User on 30/06/2022.
//

import Foundation
import CoreLocation

protocol PhotoBase {
    var id: String { get }
}

struct Photo: Codable, Identifiable, PhotoBase {
    let id: String
    let raw: String?
    let thumb: String?
    let created_at: Date?
    let user: User?
    let color: String?
    let likes: Int
    let width: Int
    let height: Int
    let description: String?
    let location: Location?
    let coordinate: CLLocationCoordinate2D?

    enum CodingKeys: String, CodingKey {
        case id
        case urls
        case user
        case created_at
        case color
        case likes
        case width
        case height
        case description
        case location
    }

    enum UrlsKeys: String, CodingKey {
        case raw
        case thumb
        case createdAt
        case color
        case likes
        case width
        case height
        case description
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Photo.CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        let urls = try values.nestedContainer(keyedBy: UrlsKeys.self, forKey: .urls)
        raw = try urls.decode(String.self, forKey: .raw)
        thumb = try urls.decode(String.self, forKey: .thumb)
        user = try values.decode(User.self, forKey: .user)
        let time = try values.decode(String.self, forKey: .created_at)
        created_at = DateFormatter.parseTime(time: time)
        color = try values.decode(String.self, forKey: .color)
        likes = try values.decode(Int.self, forKey: .likes)
        width = try values.decode(Int.self, forKey: .width)
        height = try values.decode(Int.self, forKey: .height)
        do {
            description = try values.decode(String.self, forKey: .description)
        } catch {
            description = nil
        }
        do {
            location = try values.decode(Location.self, forKey: .location)
            if location != nil {
                coordinate = CLLocationCoordinate2D(latitude: location!.lat!, longitude: location!.lon!)
            } else {
                coordinate = nil
            }
        } catch {
            location = nil
            coordinate = nil
        }
    }

    init(id: String,
         color: String?,
         user: User?,
         raw: String?,
         thumb: String?,
         likes: Int,
         width: Int,
         height: Int,
         description: String?,
         created_at: Date?,
         location: Location?,
         downloads: Int?) {
        self.id = id
        self.color = color
        self.user =  user
        self.raw = raw
        self.likes = likes
        self.width = width
        self.height = width
        self.thumb = thumb
        self.created_at = created_at
        self.description = description

        if (location != nil && location?.lat != 0 && location?.lon != 0) {
            self.coordinate = CLLocationCoordinate2D(latitude: location!.lat!, longitude: location!.lon!)
        } else {
            self.coordinate = nil
        }
        self.location = location
    }

    init() {
        id =  ""
        color = nil
        user = nil
        created_at = nil
        location = nil
        raw = ""
        likes = 0
        width = 0
        height = 0
        thumb = nil
        coordinate = nil
        description = nil
    }

    func encode(to encoder: Encoder) throws {

    }
}
