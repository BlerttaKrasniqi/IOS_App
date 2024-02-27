//
//  Note.swift
//  NoteApp
//
//  Created by Blerta on 2/26/24.
//

import CoreData

@objc(Note)
class Note: NSManagedObject {
    @NSManaged var id: NSNumber!
    @NSManaged var titulli: String!
    @NSManaged var pershkrimi: String!
    @NSManaged var deletedDate: Date!
    @NSManaged var isRecycled: Bool
}
