//  File: PersistenceManager.swift
//  Project: Project31-Multibrowser
//  Created by: Noah Pope on 5/28/25.

import Foundation

enum PersistenceManager
{
    static private let defaults = UserDefaults.standard

    static var isFirstVisitStatus: Bool! = true {
        didSet { PersistenceManager.save(firstVisitStatus: self.isFirstVisitStatus) }
    }
    
    
    static func save(firstVisitStatus: Bool)
    {
        do {
            let encoder = JSONEncoder()
            let encodedStatus = try encoder.encode(firstVisitStatus)
            defaults.set(encodedStatus, forKey: SaveKeys.isFirstVisit)
        } catch {
            print("cannot save is first visit bool")
        }
    }
    
    
    static func retrieveFirstVisitStatus() -> Bool
    {
        guard let visitStatusData = defaults.object(forKey: SaveKeys.isFirstVisit) as? Data
        else { return true }
        
        do {
            let decoder = JSONDecoder()
            let savedStatus = try decoder.decode(Bool.self, from: visitStatusData)
            return savedStatus
        } catch {
            print("unable to load first visit status")
            return true
        }
    }
}
