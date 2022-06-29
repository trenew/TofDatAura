//
//  TofDatAuraApp.swift
//  TofDatAura
//
//  Created by User on 29/06/2022.
//

import SwiftUI

@main
struct TofDatAuraApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
