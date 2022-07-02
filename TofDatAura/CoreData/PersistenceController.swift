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
            let error = error as NSError
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }

    func delete(id: String){
        let fetchRequest = NSFetchRequest<LikedPhoto>(entityName: "LikedPhoto")
        fetchRequest.predicate = NSPredicate(format: "id== %@", id)
        let objects = try! self.container.viewContext.fetch(fetchRequest)
        for obj in objects {
            self.container.viewContext.delete(obj)
        }

        do {
            try self.container.viewContext.save()
        } catch {
            // Handle errors in the database
            let error = error as NSError
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }

    func addPhoto(photo: PhotoDetailed, context: NSManagedObjectContext) {
        let new_photo = LikedPhoto(context: context)
        new_photo.id = photo.id
        new_photo.created_at = photo.created_at
        new_photo.added_at = Date()
        new_photo.username = photo.user?.username
        new_photo.realname = photo.user?.name
        new_photo.country = photo.location?.country
        new_photo.city = photo.location?.city
        new_photo.downloads = Int32(photo.downloads ?? 0)
        new_photo.color = photo.id
        if (photo.location != nil && photo.location?.lat != nil && photo.location?.lon != nil) {
            new_photo.lon = photo.location!.lon!
            new_photo.lat = photo.location!.lat!
        }
        new_photo.raw_url = photo.raw
        new_photo.thumb_url = photo.thumb
        new_photo.likes = Int32(photo.likes)
        new_photo.width = Int16(photo.width)
        new_photo.height = Int16(photo.height)
        new_photo.desc = photo.description
        save(context: context)
    }

    func isLiked(id: String) -> Bool {
        let req = NSFetchRequest<LikedPhoto>(entityName: "LikedPhoto")
        req.predicate = NSPredicate(format: "id == %@", id)
        do {
            let fetch = try self.container.viewContext.fetch(req)
            if (fetch.isEmpty)
            {
                return false
            } else {
                return true
            }
        }
        catch  {
            return false
        }
    }
}
