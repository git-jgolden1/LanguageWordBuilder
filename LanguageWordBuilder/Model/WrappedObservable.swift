//
//  Internalized.swift
//  LanguageWordBuilder
//
//  Created by Jonathan Gurr on 1/20/21.
//

import SwiftUI

@propertyWrapper
class WrappedObservable<T> {
	var wrappedValue: T {
		get {
			return projectedValue.observable.state
		}
		set {
			projectedValue.observable.state = newValue
		}
	}
	var observable: Observable<T>
	var projectedValue: ObservableBinding<T>
	
	init(wrappedValue: T) {
		observable = Observable(wrappedValue)
		//projectedValue needs a default value because of compiler weakness
		projectedValue = ObservableBinding(observable: Observable(wrappedValue), binding: Binding(get: { wrappedValue }, set: { _ in }))
		let ob: ObservableBinding<T> = ObservableBinding(observable: observable, binding: Binding(get: { self.observable.state }, set: { self.observable.state = $0 }))
		self.projectedValue = ob
	}
}

struct ObservableBinding<T> {
	
	var observable: Observable<T>
	var binding: Binding<T>
}

