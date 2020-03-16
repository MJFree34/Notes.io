//
//  DetailViewController.swift
//  Consolidation8
//
//  Created by Matt Free on 3/15/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var notes = [Note]()
    var note = Note(title: "", note: "", date: Date(timeIntervalSinceNow: 0))
    var noteIndex = 0
    
    @IBOutlet var noteArea: UITextView!
    @IBOutlet var titleLabel: UITextField!
    @IBOutlet var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = note.title
        noteArea.text = note.note
        
        let date = note.date
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("dd-MM-yy")
        dateLabel.text = dateFormatter.string(from: date)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        syncNote()
        
        if let savedData = try? jsonEncoder.encode(notes) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "notes")
        } else {
            print("Unable to save data")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        save()
    }
    
    func syncNote() {
        note.note = noteArea.text
        note.title = titleLabel.text!
        
        notes[noteIndex].note = note.note
        notes[noteIndex].title = note.title
        notes[noteIndex].date = note.date
    }
}
