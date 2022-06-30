//
//  CircleImage.swift
//  TofDatAura
//
//  Created by User on 01/07/2022.
//

import SwiftUI

struct CircleImage: View {
    var url: String
    
    var body: some View {
        RemoteImage(url: DetailViewModel.createRetinaPhotoUrl(url: self.url))
            .scaledToFit()
            .frame(width: 180, height: 180, alignment: .center)
            .clipShape(Circle())
            .shadow(radius: 7)
    }
}
