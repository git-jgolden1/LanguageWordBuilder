//
//  Internalized.swift
//  LanguageWordBuilder
//
//  Created by Jonathan Gurr on 1/20/21.
//

import Foundation

@propertyWrapper
class WrappedObservable<T> {
	var wrappedValue: T {
		get {
			return projectedValue.state
		}
		set {
			projectedValue.state = newValue
		}
	}
	var projectedValue: Observable<T>
	init(wrappedValue: T) {
		self.projectedValue = Observable(wrappedValue)
	}
}
