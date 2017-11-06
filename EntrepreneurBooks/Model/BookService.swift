//
//  BookService.swift
//  EntrepreneurBooks
//
//  Created by Priyanka Pote on 06/11/17.
//  Copyright © 2017 VamshiKrishna. All rights reserved.
//

import Foundation
import CoreData

class BookService {
    
    internal static func getBooks(managedObjectContext:NSManagedObjectContext) -> NSFetchedResultsController<Book> {
        let fetchedResultController: NSFetchedResultsController<Book>
        
        let request: NSFetchRequest<Book> = Book.fetchRequest()
        let sort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sort]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultController.performFetch()
        }
        catch {
            fatalError("Error in fetching records")
        }
        
        return fetchedResultController
    }
}
