//
//  BackEnd.swift
//  LanguageWordBuilder
//
//  Created by Jonathan Gurr on 12/31/20.
//

import Foundation

func setUpBackEndListeners() {
	addAppStateListener(appState.$currentAnswer, listenerType: .backEnd)
	addAppStateListener(appState.$currentWord, listenerType: .backEnd)
	addAppStateListener(appState.$currentWordIndex, listenerType: .backEnd)
	addAppStateListener(appState.$isSelected, listenerType: .backEnd)
	addAppStateListener(appState.$numberOfColumns, listenerType: .backEnd)
	addAppStateListener(appState.$score, listenerType: .backEnd)
	addAppStateListener(appState.$scrambledLetters, listenerType: .backEnd)
}

func saveModel() {
	let context = PersistenceController.shared.container.viewContext
	let appStateDB = AppStateDB(context: context)
	appStateDB.currentAnswer = "bla"
//	appStateDB.currentWordIndex = Int32(appState.currentWordIndex)
//	appStateDB.isSelected = ""
//	for b in appState.isSelected {
//		if b {
//			appStateDB.isSelected += "t"
//		} else {
//			appStateDB.isSelected += "f"
//		}
//	}
//	appStateDB.numberOfColumns = Int16(appState.numberOfColumns)
//	appStateDB.score = Int16(appState.score)
//	appStateDB.scrambledLetters = ""
//	for letter in appState.scrambledLetters {
//		appStateDB.scrambledLetters += letter
//	}
//	appStateDB.save()
}

func loadModel() {
	let appStateDB = AppStateDB.fetch(context: PersistenceController.shared.context)
	appState.currentAnswer = appStateDB.currentAnswer
//	appState.currentWordIndex = Int(appStateDB.currentWordIndex)
//	appState.isSelected = [Bool]()
//	for c in appStateDB.isSelected {
//		if c == "t" {
//			appState.isSelected.append(true)
//		} else if c == "f" {
//			appState.isSelected.append(false)
//		} else {
//			print("invalid string value for isSelected appStateDB")
//		}
//	}
//
//	appState.numberOfColumns = Int(appStateDB.numberOfColumns)
//	appState.score = Int(appStateDB.score)
//	appState.scrambledLetters = [String]()
//	for c in appStateDB.scrambledLetters {
//		appState.scrambledLetters.append(String(c))
//  }
}
