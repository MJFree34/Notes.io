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
        let date = Date(timeIntervalSinceNow: 0)
        print(date)
        
        notes.append(Note(title: "Test Note", subtitle: "This is a super long test note to see if the notes will actually work on the screen.", date: Date(timeIntervalSinceNow: 0)))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            notes.insert(Note(title: "New Note", subtitle: "Text here...", date: Date(timeIntervalSinceNow: 0)), at: indexPath.row)
            tableView.insertRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath) as? NoteCell else {
            fatalError("Could not dequeue a NoteCell")
        }
        cell.titleLabel.text = notes[indexPath.row].title
        cell.subtitleLabel.text = notes[indexPath.row].subtitle
        
        let date = notes[indexPath.row].date
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("dd-MM-yy")
        cell.dateLabel.text = dateFormatter.string(from: date)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
