//
//  ItemListViewController.swift
//  ToDude
//
//  Created by Denis M on 2020-03-02.
//  Copyright © 2020 Denis M. All rights reserved.
//

import UIKit
import CoreData

class ItemListViewController: UITableViewController {
  var items = [Item]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
      return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)

        // Configure the cell...
      let item = items[indexPath.row]
      cell.textLabel?.text = item.title
      cell.accessoryType = item.completed ? .checkmark : .none

        return cell
    }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = items[indexPath.row]
    item.completed = !item.completed
    <#code#>
  }


}
