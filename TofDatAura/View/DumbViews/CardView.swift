//
//  CardView.swift
//  TofDatAura
//
//  Created by User on 01/07/2022.
//

import SwiftUI

struct CardView: View {
    @State private var show = false
    var minY: CGFloat
    var imageURL: URL
    var photo: Photo

    var body: some View {
        ZStack {
            ZStack {
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.white]), startPoint: .top, endPoint: .bottom))
                    .cornerRadius(50)
                    .shadow(color: Color(.sRGBLinear, red: 0/255, green: 0/255, blue: 0/255).opacity(0.5), radius: 45, x: 8, y: 38)
                    .padding()
                VStack(spacing: 10) {
                    CircleImage(url: photo.user?.large ?? Constants.unknowPictureUrl)
                    HStack {
                        Text("\(photo.user?.name ?? String(""))")
                            .font(.system(size: 20, weight: .semibold, design: .default))
                        Spacer()
                        HStack(spacing: 7) {
                            Image(systemName: "bolt.fill")
                            Text("\(photo.likes)")
                                .foregroundColor(Color.green)
                        }
                        .foregroundColor(Color.green)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                    }
                    HStack {
                        Image(systemName: "1.magnifyingglass")
                            .font(.system(size: 14, weight: .regular, design: .monospaced))
                            .foregroundColor(Color(.systemGray))
                        Text("\(photo.width/1000)K")
                            .font(.system(size: 14, weight: .regular, design: .monospaced))
                            .foregroundColor(Color(.systemGray))
                        Spacer()
                        if let city = photo.user?.location {
                            Image(systemName: "circle.fill")
                                .font(.system(size: 4, weight: .ultraLight, design: .default))
                                .foregroundColor(Color(.systemGray))
                            Spacer()
                            Image(systemName: "location.fill")
                                .font(.system(size: 14, weight: .regular, design: .monospaced))
                                .foregroundColor(Color(.systemGray))
                            Text("\(city)")
                                .font(.system(size: 14, weight: .regular, design: .monospaced))
                                .foregroundColor(Color(.systemGray))
                            Spacer()
                        }
                    }
                    if let created_at = photo.created_at {
                        HStack {
                            Spacer()
                            Image(systemName: "camera.shutter.button.fill")
                                .font(.system(size: 14, weight: .regular, design: .monospaced))
                                .foregroundColor(Color(.systemGray))
                            Text("\(Calendar.formattedDate(created_at))").lineLimit(2)
                                .font(.system(size: 14, weight: .regular, design: .monospaced))
                                .foregroundColor(Color(.systemGray))
                            Spacer()
                        }
                    }
                }.padding(32)
            }
            .padding(16)
            .offset(x: show ? 0 : 10, y: show ? 0 : 10)
            .animation(Animation.spring(response: 0.6, dampingFraction: 0.6, blendDuration: 0).delay(0.2))

            ZStack(alignment: .bottom) {
                GeometryReader { geo in
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color(.displayP3, red: 34.65/255, green: 84.59/255, blue: 206.29/255), Color(.displayP3, red: 127.02/255, green: 165.61/255, blue: 248.35/255)]), startPoint: .top, endPoint: .bottom))
                        .cornerRadius(50)
                        .shadow(color: Color(.sRGBLinear, red: 0/255, green: 0/255, blue: 0/255).opacity(0.5), radius: 45, x: 8, y: 38)
                        .padding()
                    HStack(alignment: .center) {
                        Spacer()
                        VStack(alignment: .center) {
                            Spacer()
                            RemoteImage(url: imageURL)
                                .scaledToFit()
                                .padding(32)
                            Spacer()
                        }
                        Spacer()
                    }
                }
                if let desc = photo.description {
                    Text(desc)
                        .font(.system(size: 16, weight: .regular, design: .monospaced))
                        .lineLimit(1).foregroundColor(Color.secondary).offset(y: 38)
                }
            }
            .padding(16)
            .offset(x: show ? -333 : 0)
            .animation(.spring(response: 0.6, dampingFraction: 0.6, blendDuration: 0))
        }
        // When minY < 0 start the scaling
        .scaleEffect(minY < 0 ? minY / 1000 + 1 : 1, anchor: .bottom)
        .rotation3DEffect(
            Angle(degrees: 10),
            axis: (x: -10.0, y: 0.0, z: 0.0)
        )
        .gesture(
            DragGesture()
                .onEnded { _ in
                    self.show.toggle()
                }
        )
    }
}
