//
//  ItemListViewController.swift
//  ToDude
//
//  Created by Denis M on 2020-03-02.
//  Copyright © 2020 Denis M. All rights reserved.
//

import UIKit
import CoreData
import SwipeCellKit

class ItemListViewController: UITableViewController {
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  var items = [Item]()
  
  @IBAction func addItemButtonTapped(_ sender: UIBarButtonItem) {
    // we need this in order to access the text field data outside of the 'addTextField' scope below
    var tempTextField = UITextField()
    
    // create a UIAlertController object
    let alertController = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
    
    // create a UIAlertAction object
    let alertAction = UIAlertAction(title: "Done", style: .default) { (action) in
      // create a new item from our Item core data entity (we pass it the context)
      let newItem = Item(context: self.context)
      
      // if the text field text is not nil
      if let text = tempTextField.text {
        // set the item attributes
        newItem.title = text
        newItem.completed = false
        
        // append the item to our items array
        self.items.append(newItem)
        
        // call our saveItems() method which saves our context and reloads the table
        self.saveItems()
      }
    }
    
    alertController.addTextField { (textField) in
      textField.placeholder = "Title"
      tempTextField = textField
    }
    
    // Add the action we created above to our alert controller
    alertController.addAction(alertAction)
    // show our alert on screen
    present(alertController, animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
        super.viewDidLoad()
    tableView.rowHeight = 80.0
        loadItems()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
      return items.count
    }

    // Here we populate each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! SwipeTableViewCell
      cell.delegate = self

        // Configure the cell...
      let item = items[indexPath.row]
      cell.textLabel?.text = item.title
      cell.accessoryType = item.completed ? .checkmark : .none

        return cell
    }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = items[indexPath.row]
    item.completed = !item.completed
    saveItems()
  }
  
  // MARK: - Context access methods
  func saveItems() {
    // wrap our try statement below in a do/catch block so we can handle any errors
    do {
      // save our context
      try context.save()
    } catch {
      print("Error saving context \(error)")
    }
    
    // reload our table to reflect any changes
    tableView.reloadData()
  }
  
  func loadItems() {
    // create a new fetch request of type NSFetchRequest<Item> - you must provide a type
    let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
    
    // wrap our try statement below in a do/catch block so we can handle any errors
    do {
      // fetch our items using our fetch request, save them in our items array
      items = try context.fetch(fetchRequest)
    } catch {
      print("Error fetching items: \(error)")
    }
    
    // reload our table to reflect any changes
    tableView.reloadData()
  }

}

// separated logic
extension ItemListViewController: SwipeTableViewCellDelegate {
  //protocol
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    guard orientation == .right else { return nil }
    
    // initialize a SwipeAction object
    let deleteAction = SwipeAction(style: .destructive, title: "Delete") { _, indexPath in
      // delete the item from our context
      self.context.delete(self.items[indexPath.row])
      // remove the item from the items array
      self.items.remove(at: indexPath.row)
      
      // save our context
      self.saveItems()
    }
    
    // customize the action appearance
    deleteAction.image = UIImage(named: "trash")
    
    return [deleteAction]
  }
}
