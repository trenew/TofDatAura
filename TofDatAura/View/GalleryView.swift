//
//  GalleryView.swift
//  TofDatAura
//
//  Created by User on 30/06/2022.
//

import SwiftUI

struct GalleryView: View {
    @StateObject private var mainViewModel = GalleryViewModel()
    
    var body: some View {
        TabView {
            NavigationView {
                ScrollView(.vertical, showsIndicators: true) {
                    LazyVStack {
                        ForEach(self.mainViewModel.photos, id: \.self.id) { photo in
                            ZStack {
                                GeometryReader { geometry in
                                    RemoteImage(url: GalleryViewModel.createPhotoUrl(url: photo.raw ?? Constants.unknowPictureUrl))
                                        .scaledToFit()
                                        .padding(32)
                                    Spacer()
                                }
                                .frame(width: 256, height: 256, alignment: .center)
                            }
                            .onAppear {
                                self.mainViewModel.loadMorePhotosIfNeeded(currentPhoto: photo)
                            }
                        }
                        if (mainViewModel.isLoadingPage) {
                            HStack() {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        }
                    }
                }.navigationTitle("Today")
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Image(systemName: "photo.on.rectangle.angled")
                Text("Gallery")
            }
        }
    }
}
