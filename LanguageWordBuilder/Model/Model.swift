//
//  Model.swift
//  LanguageWordBuilder
//
//  Created by Jonathan Gurr on 12/31/20.
//

import Foundation
import Combine

class AppState {
	private enum WordOrder {
		case nativeToForeign, foreignToNative
	}
	private var wordOrder: WordOrder = .nativeToForeign
	func switchOrder() {
		wordOrder = wordOrder == .nativeToForeign ? .foreignToNative : .nativeToForeign
	}
	@WrappedObservable var currentWordIndex = 0
	@WrappedObservable var score = 0
	@WrappedObservable var currentAnswer = ""
	var currentWord: Word {
		var result: Word
		if wordOrder == .nativeToForeign {
			result = words[currentWordIndex]
		} else {
			result = words[currentWordIndex].switchOrder()
		}
		return result
	}
	@WrappedObservable var scrambledLetters: [String] = []
	
	let subject = PassthroughSubject<ListenerType, Never>()
	
	@WrappedObservable var numberOfColumns = 2
	@WrappedObservable var isSelected = [Bool]()
	@WrappedObservable var showingWordReportAlert = false
	@WrappedObservable var showingQuitAlert = false
	@WrappedObservable var wordSource = spanishWordSource
	@WrappedObservable var wordSourceWasSelected = false

	func reset() {
		wordSourceWasSelected = false
		score = 0
	}
}


let observable_empty = Observable<Bool>(false)

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
	
	private var listeners: [ListenerType: () -> Void] = [:]
	
	func addListener(type l: ListenerType, _ listener: @escaping () -> Void) {
		listeners[l] = listener
		print("Listener added")
	}
	
//	func removeListener(_ listener: Listener) {
//		if let i = listeners.firstIndex(where: { $0 === listener }) {
//			listeners.remove(at: i)
//		}
//	}
	
	func hasListener(type l: ListenerType) -> Bool {
		return listeners.keys.contains(l)
	}
	
	init(_ state: G) {
		internalState = state
		print("state changed to \(internalState)")
	}
	
}

var appState = AppState()

enum ListenerType {
	case frontEnd
	case backEnd
}

enum FatalError: Error {
	case only(_ message: String)
}

func addAppStateListener<T>(_ ob: ObservableBinding<T>, listenerType l: ListenerType) {
	
	if !ob.observable.hasListener(type: l) {
		ob.observable.addListener(type: l) {
			appState.subject.send(l)
		}
	}
	
}

