//
//  NoteManager.swift
//  iNote
//
//  Created by Mavin Sao on 27/9/21.
//

import Foundation
import UIKit
import CoreData

struct NoteManager {
    
    static let shared = NoteManager()
    
    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    func fetchNote()->[Note]{
        
        let request:NSFetchRequest<Note> = Note.fetchRequest()
        let sort = NSSortDescriptor(key: "lastUpdate", ascending: false)
        request.sortDescriptors = [sort]
        
        let notes = try? context.fetch(request)
        
        return notes ?? []
    }
    
    func insertNote(title: String, description: String){
        if title != "" || description != ""{
            let note = Note(context: context)
            note.id              = UUID()
            note.title           = title
            note.descriptionText = description
            note.lastUpdate      = Date()
            
            print("insert success")
            
            do{
                try context.save()
            }catch(let err){
                print("error: \(err)")
            }
        }
    }
    
    func updateNote(title: String, description: String, uid: UUID){
        
        if title != "" || description != ""{
            let request:NSFetchRequest<Note> = Note.fetchRequest()
            let sort = NSSortDescriptor(key: "lastUpdate", ascending: false)
            request.sortDescriptors = [sort]
            let notes = try? context.fetch(request)
            guard let allNotes = notes else {fatalError("Note Not Found")}
            if let noteUpdate = allNotes.first(where: {$0.id == uid}){
                noteUpdate.title = title
                noteUpdate.descriptionText = description
                noteUpdate.lastUpdate      = Date()
            }
            print("update success")
            
            try? context.save()
        }
    }
    
    func deleteNote(uid: UUID){
        let notes = try? context.fetch(Note.fetchRequest())
        guard let allNotes = notes else {fatalError("Note Not Found")}
        let noteUpdate = allNotes.first(where: {($0 as! Note).id == uid})
        context.delete(noteUpdate as! Note)
        
        print("delete success")
        
        try? context.save()
    }
}


