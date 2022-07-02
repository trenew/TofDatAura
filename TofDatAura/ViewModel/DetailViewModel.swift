//
//  DetailViewModel.swift
//  TofDatAura
//
//  Created by User on 01/07/2022.
//

import Foundation
import CoreData
import SwiftUI
import MapKit

class DetailViewModel: ObservableObject {
    @Environment(\.managedObjectContext) var managedObjContext
    @Published var data: PhotoDetailed = PhotoDetailed()
    @Published var liked: Bool = false

    static func generateUrl(url: String) -> URL {
        let new_url = url
        return URL(string: new_url) ?? URL(string: "")!
    }

    func loadPhoto(photo: PhotoBase) {
        UnsplashService.getPhotoInfo(id: photo.id, completion: { res in
            self.data = res
            self.liked = PersistenceController.shared.isLiked(id: self.data.id)
        })
    }

    static func createRetinaPhotoUrl(url: String) -> URL {
        let new_url = url + "&dpr=2"
        return URL(string: new_url) ?? URL(string: "")!
    }

    func loadFromLiked(photo: LikedPhoto) {
        self.data =  PhotoDetailed(
            id: photo.id!,
            color: photo.color,
            user: User(from: photo.username ?? ""),
            name: photo.realname,
            raw: photo.raw_url,
            thumb: photo.thumb_url,
            created_at: photo.created_at,
            location: Location(city: photo.city, country: photo.country, lat: photo.lat, lon: photo.lon),
            downloads: Int(photo.downloads),
            likes: Int(photo.likes),
            width: Int(photo.width),
            height: Int(photo.height),
            description: photo.description
        )
        self.liked = PersistenceController.shared.isLiked(id: photo.id!)
    }

    func savePhotoToPhoneGallery() {
        guard let imageToSave = data.raw?.loadPhotoFromURL() else { return }
        UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
    }
}
