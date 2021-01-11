//
//  Model.swift
//  LanguageWordBuilder
//
//  Created by Jonathan Gurr on 12/31/20.
//

import Foundation

var currentWordIndex = 0
var isSelected: [Bool] = []
var currentAnswer = ""
var currentWord = words[0]
var scrambledLetters: [String] = []

var internalNumberOfColumns = Observable(0)

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
			listeners.forEach({ $0() })
			print("state changed to \(newState)")
		}
	
	}

	private lazy var listeners = [() -> Void]()
	
	func addListener(_ listener: @escaping () -> Void) {
		listeners.append(listener)
		print("Listener added")
	}
	
//	func removeListener(_ listener: Listener) {
//		if let i = listeners.firstIndex(where: { $0 === listener }) {
//			listeners.remove(at: i)
//		}
//	}
	
	init(_ state: G) {
		internalState = state
	}
	
}
