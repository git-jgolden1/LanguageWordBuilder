//
//  Model.swift
//  LanguageWordBuilder
//
//  Created by Jonathan Gurr on 12/31/20.
//

import Foundation
import Combine

var currentWordIndex = 0
var isSelected: [Bool] = []
var currentAnswer = ""
var currentWord = words[0]
var scrambledLetters: [String] = []

var internalNumberOfColumns = Observable(2)

var numberOfColumns: Int {
	get {
		return internalNumberOfColumns.state
	}
	set(newValue) {
		internalNumberOfColumns.state = newValue
	}
}

var score = 0

class Observable<G> {
	
	private var internalState: G
	
	var state: G {
	
		get {
			return internalState
		}
		
		set(newState) {
			internalState = newState
			listeners.values.forEach({ $0() })
		}
	
	}

	private var listeners: [String: () -> Void] = [:]
	
	func addListener(name: String, _ listener: @escaping () -> Void) {
		listeners[name] = listener
		print("Listener added")
	}
	
//	func removeListener(_ listener: Listener) {
//		if let i = listeners.firstIndex(where: { $0 === listener }) {
//			listeners.remove(at: i)
//		}
//	}
	
	func hasListener(name: String) -> Bool {
		return listeners.keys.contains(name)
	}
	
	init(_ state: G) {
		internalState = state
		print("state changed to \(internalState)")
	}
	
}

var appState = AppState()
enum ViewRefreshKey {
	case mainView
}

class AppState {
	static let subject = PassthroughSubject<ViewRefreshKey, Never>()
}