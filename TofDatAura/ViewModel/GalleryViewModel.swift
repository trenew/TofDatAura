//
//  GalleryViewModel.swift
//  TofDatAura
//
//  Created by User on 30/06/2022.
//

import Foundation
import SwiftUI

class GalleryViewModel: ObservableObject {
    @Published var photos = [Photo]()
    @Published var isLoadingPage = false
    private var canLoadMore = true
    static let screenWidth = Int(UIScreen.main.bounds.size.width)
    static let screenHeight = Int(UIScreen.main.bounds.size.height)
    
    init() {
        loadMorePhotos()
    }
    
    func loadMorePhotosIfNeeded(currentPhoto photo: Photo?) {
        guard let photo = photo else {
            loadMorePhotos()
            return
        }
        let thresholdIndex = photos.index(photos.endIndex, offsetBy: -5)
        if photos.firstIndex(where: { $0.id == photo.id }) == thresholdIndex {
            loadMorePhotos()
        }
    }
    
    func loadMorePhotos() {
        guard !isLoadingPage && canLoadMore else {
            return
        }
        isLoadingPage = true
        UnsplashService.loadTodayPhotos(count: 10, completion: { photos in self.photos.append(contentsOf: photos)
            self.isLoadingPage = false
        })
    }
    
    static func createPhotoUrl(url: String) -> URL {
        let new_url = url + "&w=" + String(GalleryViewModel.screenWidth) + "&h=" + String(GalleryViewModel.screenHeight) + "&dpr=2"
        return URL(string: new_url) ?? URL(string: "")!
    }
}
