//
//  AppDelegate.swift
//  EntrepreneurBooks
//
//  Created by Priyanka Pote on 06/11/17.
//  Copyright © 2017 VamshiKrishna. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coreData = CoreDataStack()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        checkDataStore()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        coreData.saveContext()
    }

    func checkDataStore() {
        let moc = coreData.persistentContainer.viewContext
        let request: NSFetchRequest<Book> = Book.fetchRequest()
        
        do {
            let bookCount = try moc.count(for: request)
            
            if bookCount == 0 {
                uploadSampleData()
            }
        }
        catch {
            fatalError("Error in counting movie")
        }
    }
    
    func uploadSampleData() {
        let moc = coreData.persistentContainer.viewContext
        let url = Bundle.main.url(forResource: "books", withExtension: "json")
        let data = NSData(contentsOf: url!)
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            let jsonArray = jsonResult.value(forKey: "books") as! NSArray
            
            for json in jsonArray {
                let bookData = json as! [String: AnyObject]
                let book = Book(context: moc)
                
                guard let name = bookData["name"] else {
                    return
                }
                book.name = name as? String
                
                guard let rating = bookData["rating"] else {
                    return
                }
                book.rating = rating.int16Value
                
                guard let author = bookData["author"] else {
                    return
                }
                book.author = author as? String
                
                var image: UIImage?
                if let bookImage = bookData["image"] {
                    let imageName = bookImage as? String
                    image = UIImage(named: imageName!)
                    book.image = NSData.init(data: UIImageJPEGRepresentation(image!, 1)!) as Data
                }
            }
            
            coreData.saveContext()
        }
        catch {
            fatalError("Cannot upload sample data")
        }
    }

}

