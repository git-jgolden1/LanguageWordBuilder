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
	static func fetch(context: NSManagedObjectContext) -> AppStateDB {
		var appStateDB: AppStateDB? = nil
		let request: NSFetchRequest<AppStateDB> = AppStateDB.fetchRequest()
		do {
			let appStateDBArray = try context.fetch(request)
			if let s = appStateDBArray.first {
				appStateDB = s
			}
		} catch {
			errorLog("Error fetching settings: \(error)")
		}
		if appStateDB == nil {
			appStateDB = AppStateDB(context: context)
		}
		return appStateDB!
	}
}
