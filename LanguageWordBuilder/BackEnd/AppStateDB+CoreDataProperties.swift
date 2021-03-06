//
//  AppStateDB+CoreDataProperties.swift
//  LanguageWordBuilder
//
//  Created by Jonathan Gurr on 3/15/21.
//
//

import Foundation
import CoreData


extension AppStateDB {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<AppStateDB> {
		return NSFetchRequest<AppStateDB>(entityName: "AppStateDB")
	}
	
	func save() {
		PersistenceController.shared.save()
	}
	
	@NSManaged public var currentWordIndex: Int32
	@NSManaged public var score: Int16
	@NSManaged public var currentAnswer: String
	@NSManaged public var scrambledLetters: String
	@NSManaged public var numberOfColumns: Int16
	@NSManaged public var isSelected: String
	@NSManaged public var wordSourceWasSelected: Bool
}

extension AppStateDB : Identifiable {

}
