//
//  TableViewController.swift
//  Consolidation8
//
//  Created by Matt Free on 3/14/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Default iOS things
        self.clearsSelectionOnViewWillAppear = false
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        title = "Notes"
        
        let defaults = UserDefaults.standard
        
        if let savedNotes = defaults.object(forKey: "notes") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                notes = try jsonDecoder.decode([Note].self, from: savedNotes)
            } catch {
                print("failed to acquire savedNotes")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            save()
        } else if editingStyle == .insert {
            notes.insert(Note(title: "New Note", note: "Text here...", date: Date(timeIntervalSinceNow: 0)), at: indexPath.row)
            tableView.insertRows(at: [indexPath], with: .fade)
            save()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath) as? NoteCell else {
            fatalError("Could not dequeue a NoteCell")
        }
        cell.titleLabel.text = notes[indexPath.row].title
        cell.noteLabel.text = notes[indexPath.row].note
        
        let date = notes[indexPath.row].date
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("dd-MM-yy")
        cell.dateLabel.text = dateFormatter.string(from: date)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            vc.note = notes[indexPath.row]
            vc.notes = notes
            vc.noteIndex = indexPath.row
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(notes) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "notes")
        } else {
            print("Unable to save data")
        }
    }
}
