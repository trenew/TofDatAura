//
//  DetailViewModel.swift
//  TofDatAura
//
//  Created by User on 01/07/2022.
//

import Foundation
import SwiftUI

class DetailViewModel: ObservableObject {
    @Environment(\.managedObjectContext) var managedObjContext
    @Published var data: PhotoDetailed = PhotoDetailed()
    
    static func generateUrl(url: String) -> URL {
        let new_url = url
        return URL(string: new_url) ?? URL(string: "")!
    }
    
    func loadPhoto(photo: PhotoBase) {
        UnsplashService.getPhotoInfo(id: photo.id, completion: { res in
            self.data = res
        })
    }
    
    static func createRetinaPhotoUrl(url: String) -> URL {
        let new_url = url + "&dpr=2"
        return URL(string: new_url) ?? URL(string: "")!
    }
}
