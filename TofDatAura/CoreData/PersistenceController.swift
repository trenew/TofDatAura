//
//  PersistenceController.swift
//  TofDatAura
//
//  Created by User on 29/06/2022.
//

import Foundation
import CoreData
import SwiftUI

class PersistenceController: ObservableObject {
    let container = NSPersistentContainer(name: "TofDatAura")
    static var shared = PersistenceController()

    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }

    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            // Handle errors in the database
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
