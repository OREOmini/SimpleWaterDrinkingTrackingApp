//
//  AppDelegate.swift
//  drink
//
//  Created by wangyunwen on 18/4/12.
//  Copyright © 2018年 YunwenWang. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
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
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "drink")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    

    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
//    func application(application: UIApplication,
//                     didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
//        
//        if  UserDefaults.standard.bool(forKey: "everLaunched") == false {
//            UserDefaults.standard.set(true, forKey: "everLaunched")
//            UserDefaults.standard.set(true, forKey: "firstLaunch")
//        }else{
//            UserDefaults.standard.set(false, forKey: "firstLaunch")
//        }
//    }
    


}

let app = UIApplication.shared.delegate as! AppDelegate
let context = app.persistentContainer.viewContext


func getDrinkingAmount() -> Int {
    
    let fetchRequest = NSFetchRequest<Amount>(entityName:"Amount")
    var num = 0
    
    do {
        let fetchedObjects = try context.fetch(fetchRequest)
        
        //遍历查询的结果
        for info in fetchedObjects{
            num = Int(info.drinkingAmount)
        }
    }
    catch {
        fatalError("不能保存：\(error)")
    }
    
    return num
}

func getTotalAmount() -> Int {
   
    let fetchRequest = NSFetchRequest<Amount>(entityName:"Amount")
    var num = 0
    
    do {
        let fetchedObjects = try context.fetch(fetchRequest)
        
        //遍历查询的结果
        for info in fetchedObjects{
            print("id=\(info.drinkingAmount)")
            num = Int(info.totalAmount)
        }
    }
    catch {
        fatalError("不能保存：\(error)")
    }
    
    return num
}

func changeCoreDataDrinkingAmountTo(newAmount: Int?) {
    let fetchRequest = NSFetchRequest<Amount>(entityName:"Amount")
    
    do {
        let fetchedObjects = try context.fetch(fetchRequest)
        for info in fetchedObjects{
            info.drinkingAmount = Int16(newAmount!)
            try context.save()
        }
        
    } catch {
        fatalError("不能保存：\(error)")
    }
}

func changeCoreDataTotalAmountTo(newAmount: Int?) {
  
    let fetchRequest = NSFetchRequest<Amount>(entityName:"Amount")
    
    do {
        let fetchedObjects = try context.fetch(fetchRequest)
        for info in fetchedObjects{
            print("id=\(info.totalAmount)")
            
            info.totalAmount = Int16(newAmount!)
            try context.save()
        }
        
    } catch {
        fatalError("不能保存：\(error)")
    }
}

func deleteAll() {
    let fetchRequest = NSFetchRequest<Amount>(entityName:"Amount")
    
    do {
        let fetchedObjects = try context.fetch(fetchRequest)
        for info in fetchedObjects{
            context.delete(info)
            try context.save()
        }
        
    } catch {
        fatalError("不能删除：\(error)")
    }
}

func hasData() -> Bool {
    let fetchRequest = NSFetchRequest<Amount>(entityName:"Amount")
    var f = false
    
    do {
        let fetchedObjects = try context.fetch(fetchRequest)
        for _ in fetchedObjects{
            f = true
            print("hasData")
        }
        
    } catch {
        fatalError("不能删除：\(error)")
    }
    return f
}


