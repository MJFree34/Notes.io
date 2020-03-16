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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        titleLabel.text = note.title
        noteArea.text = note.note
        
        let date = note.date
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("dd-MM-yy")
        dateLabel.text = dateFormatter.string(from: date)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let compose = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(newNote))
        
        toolbarItems = [spacer, compose]
        navigationController?.isToolbarHidden = false
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
    
    @objc func newNote() {
        let note = Note(title: "New Note", note: "Text here...", date: Date(timeIntervalSinceNow: 0))
        notes.append(note)
        
        save()
        
        noteArea.text = note.note
        titleLabel.text = note.title
        
        let date = note.date
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("dd-MM-yy")
        dateLabel.text = dateFormatter.string(from: date)
        
        noteIndex = notes.count - 1
    }
    
    @objc func shareTapped() {
        let vc = UIActivityViewController(activityItems: [note.title, note.note, note.date], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            noteArea.contentInset = .zero
        } else {
            noteArea.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        noteArea.scrollIndicatorInsets = noteArea.contentInset
        
        let selectedRange = noteArea.selectedRange
        noteArea.scrollRangeToVisible(selectedRange)
    }
}
