//
//  BookTableViewController.swift
//  EntrepreneurBooks
//
//  Created by Priyanka Pote on 06/11/17.
//  Copyright © 2017 VamshiKrishna. All rights reserved.
//

import UIKit
import CoreData

class BookTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var fetchedResultsController : NSFetchedResultsController<Book>!
    var bookToDelete:Book?
    var coreData = CoreDataStack()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections{
            return sections.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections{
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath) as! BookTableViewCell
        let book = fetchedResultsController.object(at: indexPath)
        cell.configureCell(book: book)
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let managedObjectContext = coreData.persistentContainer.viewContext
        if editingStyle == .delete{
            bookToDelete = fetchedResultsController.object(at: indexPath)
            let alertController = UIAlertController(title: "Remove Book", message: "Are you sure you want to delete \(bookToDelete?.name) from your bookshelf?", preferredStyle: UIAlertControllerStyle.actionSheet)
            let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.default, handler: { [weak self](action:UIAlertAction) in
                managedObjectContext.delete((self?.bookToDelete!)!)
                self?.coreData.saveContext()
                self?.bookToDelete = nil
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {[weak self] (action:UIAlertAction) in
                self?.bookToDelete = nil
            })
            alertController.addAction(deleteAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func updateRatingClicked(_ sender: Any) {
        let managedObjectContext = coreData.persistentContainer.viewContext
        let batchUpdateRequest = NSBatchUpdateRequest(entityName: "Book")
        batchUpdateRequest.propertiesToUpdate = ["rating":5]
        batchUpdateRequest.resultType = .updatedObjectIDsResultType
        
        do{
            let batchUpdateResult = try managedObjectContext.execute(batchUpdateRequest) as? NSBatchUpdateResult
            
            if let result = batchUpdateResult{
                let objectIds = result.result as! [NSManagedObjectID]
                for objectId in objectIds{
                    let managedObject = managedObjectContext.object(with: objectId)
                    if(!managedObject.isFault){
                        managedObjectContext.stalenessInterval = 0
                        managedObjectContext.refresh(managedObject, mergeChanges: true)
                    }
                }
            }
        }catch{
            
        }
    }
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type{
        case .delete:
            if let deleteIndexPath = indexPath{
                tableView.deleteRows(at: [deleteIndexPath], with: UITableViewRowAnimation.fade)
            }
        case .insert:
            print("Insert")
        case .move:
            print("Move")
        case .update:
            tableView.reloadRows(at: [indexPath!], with: UITableViewRowAnimation.fade)
            
        }
       
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    private func loadData(){
        fetchedResultsController = BookService.getBooks(managedObjectContext: coreData.persistentContainer.viewContext)
        fetchedResultsController.delegate = self
    }
}
