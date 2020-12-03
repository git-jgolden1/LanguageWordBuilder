//
//  Words.swift
//  LanguageWordBuilder
//
//  Created by Jonathan Gurr on 05-10-20.
//

import Foundation

struct Word: Hashable {
	let foreign: String
	let native: String
	let foreignDescription: String
	let nativeDescription: String
	func switchOrder() -> Word {
		let newForeign = self.native
		let newNative = self.foreign
		let newForeignDescription = self.nativeDescription
		let newNativeDescription = self.foreignDescription
		return Word(foreign: newForeign, native: newNative, foreignDescription: newForeignDescription, nativeDescription: newNativeDescription)
	}
}

let wordSource = spanishWordSource

var words: [Word] = stride(from: 0, to: wordSource.count - 1, by: 2).map {
	let foreignDescription = wordSource[$0].count > 1 ? wordSource[$0][1] : wordSource[$0][0]
	let nativeDescription = wordSource[$0 + 1].count > 1 ? wordSource[$0 + 1][1] : wordSource[$0 + 1][0]
	return Word(foreign: wordSource[$0][0], native: wordSource[$0 + 1][0], foreignDescription: foreignDescription, nativeDescription: nativeDescription)
}
