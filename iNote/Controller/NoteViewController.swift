//
//  NoteViewController.swift
//  iNote
//
//  Created by Mavin Sao on 27/9/21.
//

import UIKit

class NoteViewController: UIViewController {
    
    @IBOutlet weak var noteTextView: UITextView!
    
    var note: Note?
    
    lazy var noteTitle: String = {
        return noteTextView.text.firstLine
    }()
    lazy var noteDescription: String = {
        return noteTextView.text.afterFirstLine
    }()
    
    lazy var isUpdate: Bool = {
        if let indexNote = note {
            return true
        }else{
            return false
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar
        
        if let safeNote = note {
            self.noteTextView.text = "\(safeNote.title!)\n\(safeNote.descriptionText!)"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    
        
        if isUpdate {
            guard let updateNote = note else {
                 return
             }
            NoteManager.shared.updateNote(title: noteTitle, description: noteDescription, uid: updateNote.id!)
        }else{
            NoteManager.shared.insertNote(title: noteTitle, description: noteDescription)
        }
    }
    
    
    
}
