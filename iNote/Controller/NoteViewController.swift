//
//  NoteViewController.swift
//  iNote
//
//  Created by Mavin Sao on 27/9/21.
//

import UIKit

class NoteViewController: UIViewController {
    
    @IBOutlet weak var noteTextView: UITextView!
    
    let headerAttributes = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 25.0)]
    
    let bodyAttributes = [NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)]
    
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
    
    let isEnter: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.noteTextView.delegate = self
        let _ = self.noteTextView.becomeFirstResponder()
    
        
        if let safeNote = note {
            self.noteTextView.text = "\(safeNote.title!)\n\(safeNote.descriptionText!)"
            
            self.highlightFirstLineInTextView(textView: self.noteTextView)
            
            
        }
    }
    
    private func highlightFirstLineInTextView(textView: UITextView) {
        let textAsNSString = textView.text as NSString
        let lineBreakRange = textAsNSString.range(of: "\n")
        let newAttributedText = NSMutableAttributedString(attributedString: textView.attributedText)
        
        let boldRange: NSRange
        
        if lineBreakRange.location < textAsNSString.length {
            boldRange = NSRange(location: 0, length: lineBreakRange.location)
        } else {
            boldRange = NSRange(location: 0, length: textAsNSString.length)
        }
        
        newAttributedText.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 25.0), range: boldRange)
        
        textView.attributedText = newAttributedText
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        // Restore the navigation bar to default
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        
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

extension NoteViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let textAsNSString = self.noteTextView.text as NSString
        
        let replaced = textAsNSString.replacingCharacters(in: range, with: text) as NSString
        
        let boldRange = replaced.range(of: "\n")
        
            if boldRange.location <= range.location {
                self.noteTextView.typingAttributes = self.bodyAttributes
            } else {
                self.noteTextView.typingAttributes = self.headerAttributes
            }
            
            return true
    }
}

