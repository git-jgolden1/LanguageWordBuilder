//
//  Model.swift
//  LanguageWordBuilder
//
//  Created by Jonathan Gurr on 12/31/20.
//

import Foundation
import Combine


class AppState {
	
	@WrappedObservable var currentWordIndex = 0
	@WrappedObservable var score = 0
	@WrappedObservable var currentAnswer = ""
	@WrappedObservable var currentWord = words[0]
	@WrappedObservable var scrambledLetters: [String] = []
	
	let subject = PassthroughSubject<ViewRefreshKey, Never>()
	
	@WrappedObservable var numberOfColumns = 2
	@WrappedObservable var isSelected = [Bool]()
}

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

func addAppStateListener<T>(_ o: Observable<T>) {
	if !o.hasListener(name: "frontEnd") {
		o.addListener(name: "frontEnd")
			{ appState.subject.send(ViewRefreshKey.mainView) }
	}
}

