//
//  LikedView.swift
//  TofDatAura
//
//  Created by User on 02/07/2022.
//

import SwiftUI

struct LikedView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.added_at)])
    var photos: FetchedResults<LikedPhoto>

    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ScrollView {
                    let width = geo.size.width * 0.38
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: width))], spacing: 16) {
                        ForEach(photos, id: \.self) { item in
                            VStack{
                                NavigationLink(destination: DetailView(likedPhoto: item)) {
                                    RemoteImage(url:  DetailViewModel.createRetinaPhotoUrl(url: item.thumb_url!))
                                        .frame(width: width * 0.75,
                                               height: width * 0.75)
                                        .scaledToFit()
                                }.contentShape(Rectangle())
                                Text(item.username!).font(.system(size: 14, weight: .regular, design: .monospaced))
                                    .lineLimit(1).foregroundColor(Color.secondary).padding(.bottom, 3)
                            }
                        }
                    }.padding(.horizontal)
                }
            }.navigationTitle("Liked")
        }
    }
}

struct LikedView_Previews: PreviewProvider {
    static var previews: some View {
        LikedView()
    }
}
