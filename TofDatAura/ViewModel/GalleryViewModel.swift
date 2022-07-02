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
    private var order = Order.latest
    private var query: String = ""
    private var totalPages: Int = 0
    private var curPage: Int = 0
    private(set) var mode = Mode.today
    static let screenWidth = Int(UIScreen.main.bounds.size.width)
    static let screenHeight = Int(UIScreen.main.bounds.size.height)

    init() {
        loadMorePhotos()
    }

    func loadMorePhotosIfNeeded(currentPhoto ph: Photo?) {
        guard let ph = ph else {
            loadMorePhotos()
            return
        }
        let thresholdIndex = photos.index(photos.endIndex, offsetBy: -5)
        if photos.firstIndex(where: { $0.id == ph.id }) == thresholdIndex {
            loadMorePhotos()
        }
    }

    func loadMorePhotos() {
        guard !isLoadingPage && canLoadMore else {
            return
        }
        isLoadingPage = true
        if (self.mode == Mode.search) {
            UnsplashService.searchPhotos(query: self.query, page: self.totalPages, orderBy: self.order, completion: {
                search in
                if (self.photos.isEmpty && self.totalPages == 0 && self.curPage == 0) {
                    self.totalPages = search.total_pages
                }
                self.photos.append(contentsOf: search.results)
                self.curPage += 1
                if (self.curPage >= self.totalPages) {
                    self.canLoadMore = false
                }
                self.isLoadingPage = false
            })
        } else if (self.mode == Mode.today) {
            UnsplashService.loadTodayPhotos(orderBy: self.order, completion: { photos in self.photos.append(contentsOf: photos)
                self.isLoadingPage = false
            })
        } else if (self.mode == Mode.random) {
            UnsplashService.loadRandomPhotos(orderBy: self.order, completion: { photos in self.photos.append(contentsOf: photos)
                self.isLoadingPage = false
            })
        }
    }

    static func createPhotoUrl(url: String) -> URL {
        let new_url = url + "&w=" + String(GalleryViewModel.screenWidth) + "&h=" + String(GalleryViewModel.screenHeight) + "&dpr=2"
        return URL(string: new_url) ?? URL(string: "")!
    }

    func setOrder(to: Order) -> Void {
        self.order = to
        self.photos = []
        self.totalPages = 0
        self.curPage = 0
        self.canLoadMore = true
        loadMorePhotosIfNeeded(currentPhoto: nil)
    }

    func setMode(to: Mode, query: String = "") -> Void {
        self.mode = to
        self.photos = []
        if (self.mode == Mode.search) {
            self.totalPages = 0
            self.curPage = 0
            self.query = query
        } else {
            self.totalPages = 0
            self.curPage = 0
            self.query = ""
        }
        self.canLoadMore = true
        loadMorePhotosIfNeeded(currentPhoto: nil)
    }

    func toggleRandomMode() {
        if self.mode == .today {
            self.setMode(to: .random)
        } else if self.mode == .random {
            self.setMode(to: .today)
        }
    }
}

enum Mode: String, CaseIterable  {
    case today = "today"
    case random = "random"
    case search = "search"
}

enum Order: String, CaseIterable {
    case popular = "popular"
    case latest = "latest"
    case oldest = "oldest"
}
