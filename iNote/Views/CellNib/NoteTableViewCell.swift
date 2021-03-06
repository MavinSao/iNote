//
//  NoteTableViewCell.swift
//  iNote
//
//  Created by Mavin Sao on 27/9/21.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    
    func config(note: Note){
        self.titleLabel.text = note.title
        self.descriptionLabel.text = note.descriptionText
        
        let time = note.lastUpdate!.getFormattedDate(format: "HH:mm")
        let day = note.lastUpdate!.getFormattedDate(format: "EEE")
        
        self.lastUpdateLabel.text = "\(day) . \(time)"
    }
    
}
