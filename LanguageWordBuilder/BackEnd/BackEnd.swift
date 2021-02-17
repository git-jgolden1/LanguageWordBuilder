//
//  BackEnd.swift
//  LanguageWordBuilder
//
//  Created by Jonathan Gurr on 12/31/20.
//

import Foundation

func setUpBackEndListeners() {
	addAppStateListener(appState.$numberOfColumns, listenerType: .backEnd)
	addAppStateListener(appState.$isSelected, listenerType: .backEnd)
	addAppStateListener(appState.$currentAnswer, listenerType: .backEnd)
	addAppStateListener(appState.$score, listenerType: .backEnd)
}
