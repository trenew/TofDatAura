//
//  GalleryView.swift
//  TofDatAura
//
//  Created by User on 30/06/2022.
//

import SwiftUI

struct GalleryView: View {
    @StateObject private var galleryViewModel = GalleryViewModel()
    @State private var searchText = ""
    @State private var showingSheet = false
    @State private var orderBy = Order.latest {
        didSet {
            self.galleryViewModel.setOrder(to: orderBy)
        }
    }
    @Environment(\.isSearching) private var isSearching: Bool
    @Environment(\.dismissSearch) private var dismissSearch

    var sheet: ActionSheet {
        ActionSheet(title: Text(""), message: Text("Default is ~Latest~"), buttons: [ .default(Text("Popular"), action: { self.orderBy = Order.popular }), .default(Text("Latest"), action: { self.orderBy = Order.latest }), .default(Text("Oldest"), action: { self.orderBy = Order.oldest }), .cancel()])
    }

    var body: some View {
        TabView {
            NavigationView {
                ScrollView(.vertical, showsIndicators: true) {
                    LazyVStack {
                        ForEach(self.galleryViewModel.photos, id: \.self.id) { photo in
                            NavigationLink(destination: DetailView(photo: photo)) {
                                GeometryReader { geometry in
                                    CardView(minY: geometry.frame(in: .global).minY, imageURL: GalleryViewModel.createPhotoUrl(url: photo.raw ?? ""), photo: photo)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 440)
                            }
                            .onAppear {
                                self.galleryViewModel.loadMorePhotosIfNeeded(currentPhoto: photo)
                            }
                        }
                        if (galleryViewModel.isLoadingPage) {
                            HStack() {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        }
                    }
                }.navigationBarItems(trailing: Button(action: {
                    self.showingSheet = true
                }, label: { Text("Order by") } ))
                .actionSheet(isPresented: $showingSheet, content: { sheet })
                .navigationTitle("\(self.galleryViewModel.mode.rawValue.capitalized) – \(Text(self.orderBy.rawValue))")
            }
            .searchable(text: $searchText).onSubmit(of: .search, {
                self.galleryViewModel.setMode(to: .search, query: searchText)
            }).onChange(of: searchText, perform: { value in
                if searchText.isEmpty && !isSearching {
                    self.galleryViewModel.setMode(to: .today)
                }
            })
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Image(systemName: "photo.on.rectangle.angled")
                Text("Gallery")
            }
            LikedView()
                .tabItem {
                    Image(systemName: "heart.circle.fill")
                    Text("Liked")
                }
        }.onShake {
            self.galleryViewModel.toggleRandomMode()
        }
    }
}
