//
//  BackEnd.swift
//  LanguageWordBuilder
//
//  Created by Jonathan Gurr on 12/31/20.
//

import Foundation

var appStateDB: AppStateDB = AppStateDB()

func setUpBackEndListeners() {
	addAppStateListener(appState.$currentAnswer, listenerType: .backEnd)
	addAppStateListener(appState.$currentWordIndex, listenerType: .backEnd)
	addAppStateListener(appState.$isSelected, listenerType: .backEnd)
	addAppStateListener(appState.$numberOfColumns, listenerType: .backEnd)
	addAppStateListener(appState.$score, listenerType: .backEnd)
	addAppStateListener(appState.$scrambledLetters, listenerType: .backEnd)
	addAppStateListener(appState.$wordSource, listenerType: .backEnd)
	addAppStateListener(appState.$wordSourceWasSelected, listenerType: .backEnd)
}

func saveModel() {
	print("Save model was called")
	let context = PersistenceController.shared.container.viewContext
	appStateDB.currentWordIndex = Int32(appState.currentWordIndex)
	print("Save current word index = \(appStateDB.currentWordIndex)")
	appStateDB.isSelected = ""
	for b in appState.isSelected {
		if b {
			appStateDB.isSelected += "t"
		} else {
			appStateDB.isSelected += "f"
		}
	}
	appStateDB.numberOfColumns = Int16(appState.numberOfColumns)
	appStateDB.score = Int16(appState.score)
	appStateDB.scrambledLetters = ""
	for letter in appState.scrambledLetters {
		appStateDB.scrambledLetters += letter
	}
	appStateDB.wordSourceWasSelected = appState.wordSourceWasSelected
	appStateDB.save()
}

func loadModel() {
	print("Load model was called")
	appStateDB = AppStateDB.fetch(context: PersistenceController.shared.context)
	appState.currentAnswer = appStateDB.currentAnswer
	appState.currentWordIndex = Int(appStateDB.currentWordIndex)
	print("Loaded currentWordIndex = \(appStateDB.currentWordIndex)")
	appState.isSelected = [Bool]()
	for c in appStateDB.isSelected {
		if c == "t" {
			appState.isSelected.append(true)
		} else if c == "f" {
			appState.isSelected.append(false)
		} else {
			print("invalid string value for isSelected appStateDB")
		}
	}
	appState.numberOfColumns = Int(appStateDB.numberOfColumns)
	appState.score = Int(appStateDB.score)
	appState.scrambledLetters = [String]()
	for c in appStateDB.scrambledLetters {
		appState.scrambledLetters.append(String(c))
  }
	appState.wordSourceWasSelected = appStateDB.wordSourceWasSelected
}
