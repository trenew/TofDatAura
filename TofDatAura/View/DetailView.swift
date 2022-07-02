//
//  DetailView.swift
//  TofDatAura
//
//  Created by User on 01/07/2022.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @StateObject var detailViewModel = DetailViewModel()
    var photo: Photo?
    var likedPhoto: LikedPhoto?

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            ScrollView {
                VStack(alignment: .leading) {
                    if  (self.detailViewModel.data.thumb != nil) {
                        RemoteImage(url: DetailViewModel.createRetinaPhotoUrl(url: self.detailViewModel.data.thumb!))
                            .frame(width: width, height: 128, alignment: .top)
                            .scaledToFit()
                    }
                    Text("🤳 by \(self.detailViewModel.data.name ?? String(""))")
                        .font(.title).padding(.leading, 15)

                    HStack {
                        if let city = self.detailViewModel.data.location?.city {
                            Text(city).padding(.leading, 15)
                        }
                        Spacer()
                        if let country = self.detailViewModel.data.location?.country {
                            Text(country).padding(.trailing, 15)
                        }
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    Divider()
                    HStack {
                        Text("Image informations:").font(.title2).padding(15)
                        Spacer()
                        Button(action: {
                            if (!self.detailViewModel.liked) {
                                PersistenceController.shared
                                    .addPhoto(
                                        photo: self.detailViewModel.data,
                                        context: managedObjContext
                                    )
                            } else {
                                if let id = self.likedPhoto?.id {
                                    PersistenceController.shared.delete(id: id)
                                } else {
                                    PersistenceController.shared.delete(id: self.detailViewModel.data.id)
                                }
                            }
                            self.detailViewModel.liked = !self.detailViewModel.liked
                        }) {
                            HStack {
                                if (self.detailViewModel.liked) {
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(Color(.systemRed))
                                        .font(.system(size: 24))
                                    Text("Unlike")
                                } else {
                                    Image(systemName: "heart")
                                        .foregroundColor(Color(.systemTeal))
                                        .font(.system(size: 24))
                                    Text("Like")
                                }
                            }}
                        .buttonStyle(ScaleButtonStyle())
                        .padding([.trailing], 16)

                    }
                    HStack {
                        Image(systemName: "figure.wave")
                            .font(.system(size: 14, weight: .regular, design: .monospaced))
                            .padding(.leading, 18)
                            .frame(width: 28, height: nil, alignment: .center)
                        Text("Author: ")
                        Text((String(self.detailViewModel.data.user?.username ?? "")))
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Image(systemName: "camera.shutter.button.fill")
                            .font(.system(size: 14, weight: .regular, design: .monospaced))
                            .padding(.leading, 18)
                            .frame(width: 28, height: nil, alignment: .center)
                        Text("Created at: ")
                        Text(DateFormatter.dateToTime(date: self.detailViewModel.data.created_at))
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Image(systemName: "1.magnifyingglass")
                            .font(.system(size: 14, weight: .regular, design: .monospaced))
                            .padding(.leading, 18)
                            .frame(width: 28, height: nil, alignment: .center)
                        Text("Resolution: ")
                        Text("\(self.detailViewModel.data.width) x \(self.detailViewModel.data.height) (px)")
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Image(systemName: "square.and.arrow.down.on.square.fill")
                            .font(.system(size: 14, weight: .regular, design: .monospaced))
                            .padding(.leading, 18)
                            .frame(width: 28, height: nil, alignment: .center)
                        Text("Downloaded: ")
                        Text((String(self.detailViewModel.data.downloads ?? 0)))
                            .foregroundColor(.secondary)
                        Spacer()
                        Button(action: {
                            detailViewModel.savePhotoToPhoneGallery()
                        }) {
                            HStack {
                                Image(systemName: "square.and.arrow.down.fill")
                                    .foregroundColor(Color(.systemGreen))
                                    .font(.system(size: 24))
                                Text("Save")
                            }
                        }
                        .buttonStyle(ScaleButtonStyle())
                        .padding([.trailing], 16)
                    }
                }
                Divider()
                if let coordinate = self.detailViewModel.data.coordinate {
                    MapView(coordinate: coordinate)
                        .ignoresSafeArea(edges: .top)
                        .frame(height: 200)
                }
            }
        }.navigationTitle("Details")
            .onAppear {
                if (self.likedPhoto != nil) {
                    self.detailViewModel.loadFromLiked(photo: self.likedPhoto!)
                }
                else {
                    self.detailViewModel.loadPhoto(photo: photo!)
                }
            }
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration
            .label
            .scaleEffect(configuration.isPressed ? 2.0 : 1.0)
            .animation(Animation.spring(response: 0.7, dampingFraction: 0.7, blendDuration: 0), value: configuration.isPressed)
    }
}

struct BackgroundButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? Color.primary.opacity(0.75) : Color.primary)
            .animation(Animation.spring(response: 0.35, dampingFraction: 0.35, blendDuration: 1))
    }
}
