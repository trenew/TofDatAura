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

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if  (self.detailViewModel.data.thumb != nil) {
                    RemoteImage(url: DetailViewModel.createRetinaPhotoUrl(url: self.detailViewModel.data.thumb!))
                        .frame(width: 256, height: 256, alignment: .top)
                        .scaledToFit()
                }
                Text("🤳 by \(self.detailViewModel.data.name ?? String(""))")
                    .font(.title).padding(.leading, 15)
                HStack {
                    Text("Created at: ")
                    Text(DateFormatter.dateToTime(date: self.detailViewModel.data.created_at)).foregroundColor(.secondary)
                }
            }
        }.navigationTitle("Details")
            .onAppear {
                self.detailViewModel.loadPhoto(photo: photo!)
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
