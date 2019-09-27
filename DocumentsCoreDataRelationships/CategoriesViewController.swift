//
//  CategoriesViewController.swift
//  DocumentsCoreDataRelationships
//
//  Created by Brady Webb on 9/27/19.
//  Copyright © 2019 Brady Webb. All rights reserved.
//

import UIKit
import CoreData

class CategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var categoriesTableView: UITableView!
    var categories = [Category]()
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Categories"
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchCategories(searchString: "")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func categoryExists(name: String) -> Bool {
           guard
               let appDelegate = UIApplication.shared.delegate as? AppDelegate, name != ""
               else
               {
               return false
               }
           let managedContext = appDelegate.persistentContainer.viewContext
               let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
                   do {
                       fetchRequest.predicate = NSPredicate(format: "name == %@", name)
                       let results = try managedContext.fetch(fetchRequest)
                       if results.count > 0 {
                           return true
                       }
                       else
                       {
                           return false
                       }
                       }
                   catch {
                       return false
                   }
       }
    @IBAction func add(_ sender: Any) {
        let alert = UIAlertController(title: "Add", message: "Enter new category name.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.default, handler: {
            (alertAction) -> Void in
            if let textField = alert.textFields?[0], let name = textField.text {
                
                let categoryName = name.trimmingCharacters(in: .whitespaces)
                    if (categoryName == "") {
                        self.alertNotifyUser(message: "Category not created")
                            return
                    }
                    self.addCategory(name: categoryName)
            }
            else
            {
                self.alertNotifyUser(message: "Category not created.")
                return
            }
        }))
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
        textField.placeholder = "category name"
        textField.isSecureTextEntry = false})
        
        self.present(alert, animated: true, completion: nil)
        }
    
    func addCategory(name: String) {
        let category = Category(name: name)
        
    if let category = category {
        do {
            let managedObjectContext = category.managedObjectContext
            try managedObjectContext?.save()
            }
        }
        fetchCategories(searchString: "")
    }
    func deleteCategory(at indexPath: IndexPath) {
        let category = categories[indexPath.row]
        
        if let managedObjectContext = category.managedObjectContext {
            managedObjectContext.delete(category)
            
            do {
                try managedObjectContext.save()
                self.categories.remove(at: indexPath.row)
                categoriesTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func updateCategory(at indexPath: IndexPath, name: String) {
        let category = categories[indexPath.row]
        category.name = name
        
        if let managedObjectContext = category.managedObjectContext {
            do {
                try managedObjectContext.save()
                fetchCategories(searchString: "")
            }
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            let delete = UITableViewRowAction(style: .destructive, title: "Delete") {
            action, index in
            
                self.confirmDeleteCategory(at: indexPath)
            }
            let edit = UITableViewRowAction(style: .default, title: "Edit") { action, index    in
                self.edit(at: indexPath)
            }
        edit.backgroundColor = UIColor.blue
        
        return [delete, edit]
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DocumentsViewController,
            let row = categoriesTableView.indexPathForSelectedRow?.row {
            destination.category = categories[row]
        }
    }
}

