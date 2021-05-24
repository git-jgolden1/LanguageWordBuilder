//
//  AppStateDB+CoreDataClass.swift
//  LanguageWordBuilder
//
//  Created by Jonathan Gurr on 3/15/21.
//
//

import Foundation
import CoreData

@objc(AppStateDB)
public class AppStateDB: NSManagedObject {
	var initialized = true
	static func fetch(context: NSManagedObjectContext) -> AppStateDB {
		var appStateDB: AppStateDB? = nil
		let request: NSFetchRequest<AppStateDB> = AppStateDB.fetchRequest()
		do {
			let appStateDBArray = try context.fetch(request)
			if let s = appStateDBArray.first {
				appStateDB = s
			}
			print("appStateDB records found = \(appStateDBArray.count)")
		} catch {
			errorLog("Error fetching settings: \(error)")
		}
		if appStateDB == nil {
			appStateDB = AppStateDB(context: context)
			appStateDB!.initialized = false
		}
		return appStateDB!
	}
}
