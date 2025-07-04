//  File: AppDelegate.swift
//  Project: Project31-Multibrowser
//  Created by: Noah Pope on 5/28/25.

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate
{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration
    {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>)
    {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Project31_Multibrowser")
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

    func saveContext ()
    {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

//-------------------------------------//
// MARK: - NOTES SECTION

/**
 swift @ version: 6 (released 09.17.2024)
 iOS @ version: 18.5 (released 05.14.2025)
 xcode @ version: 16.3 (released 03.31.2025)
 --------------------------
 XXXXXXXXXXXXXXXXXXXXXXXX
 --------------------------
 PROBLEM TRACKING:
 * = problem
 >  = solution
 * kept getting error when attempting to create a webview
 >  turns out the url was misspelled
 
 * don't understand how this is accessed || why it's here:
 func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
 {
     return true
 }
 > this was an inherited feature from the UIGestureRecognizerDelegate (you're used to seeing 'override' in front of these in
 tableViews. Not sure why 'override'  isn't present but its triggered automatically.
 > same goes for this: func textFieldShouldReturn(_ textField: UITextField) -> Bool. It comes from the UITextFieldDelegate
 
 * logo launcher not working properly - I don't think I'm setting the persistence mgr's isFirstVisit prop back to true
 ... & that's why it's not (?)
 > firstly I hid the searchbar which was causing the white up top
 > then I just moved all the webview setup into the logo launcher's didfinishPlaying method via the targetVC
 --------------------------
 TECHNOLOGIES USED / LEARNED:
 * Swift
 * Xcode
 * Swift Keychain Wrapper
 --------------------------
 REFERENCES & CREDITS:
 *  KeychainOptions.swift & SwiftKeychainWrapper by MIT's James Blair on 4/24/16.
 
 --------------------------
 XXXXXXXXXXXXXXXXXXXXXXXX
 --------------------------
 */
