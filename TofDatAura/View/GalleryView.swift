//
//  GalleryView.swift
//  TofDatAura
//
//  Created by User on 30/06/2022.
//

import SwiftUI

struct GalleryView: View {
    @StateObject private var mainViewModel = GalleryViewModel()
    @State private var searchText = ""
    @State private var showingSheet = false
    
    var body: some View {
        TabView {
            NavigationView {
                ScrollView(.vertical, showsIndicators: true) {
                    LazyVStack {
                        ForEach(self.mainViewModel.photos, id: \.self.id) { photo in
                            NavigationLink(destination: DetailView(photo: photo)) {
                                GeometryReader { geometry in
                                    CardView(minY: geometry.frame(in: .global).minY, imageURL: GalleryViewModel.createPhotoUrl(url: photo.raw ?? ""), photo: photo)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 440)
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
