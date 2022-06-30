//
//  TofDatAuraApp.swift
//  TofDatAura
//
//  Created by User on 29/06/2022.
//

import SwiftUI
import CoreData

@main
struct TofDatAuraApp: App {
    @State private var showAnAlert = false
    @State private var alertData = AlertData.empty

    private var persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            GalleryView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onReceive(NotificationCenter.default.publisher(for: .showAnAlert)) { notification in
                    if let data = notification.object as? AlertData {
                        alertData = data
                        showAnAlert = true
                    }
                }
                .alert(isPresented: $showAnAlert) {
                    Alert(title: alertData.title,
                          message: alertData.message,
                          dismissButton: alertData.dismissButton)
                }
        }
    }
}
