//
//  Words.swift
//  LanguageWordBuilder
//
//  Created by Jonathan Gurr on 05-10-20.
//

import Foundation

struct Word: Hashable {
	let native: String
	let foreign: String
}

let wordSource = tagalogWordSource

var words: [Word] = {
	var words = [Word]()
	for i in 0 ..< wordSource.count / 2 {
		let wordListOrder: Bool = Int.random(in: 0...1) == 1 ? true : false
		if wordListOrder {
			words.append(Word(native: wordSource[i * 2], foreign: wordSource[i * 2 + 1]))
		} else {
			words.append(Word(native: wordSource[i * 2 + 1], foreign: wordSource[i * 2]))
		}
	}
	return words
}()
