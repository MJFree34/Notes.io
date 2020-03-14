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
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
}
