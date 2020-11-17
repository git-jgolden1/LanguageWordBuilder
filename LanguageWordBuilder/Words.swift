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

let wordSource = [
	"hello", "hola",
	"yes","sí",
	"no","no",
	"dog", "perro",
	"cat", "gato",
	"woman", "mujer",
	"man", "hombre",
	"excellently", "excelentemente",
	"light", "luz",
	"darkness", "oscuridad",
	"day", "día",
	"night", "noche",
	"supercalifragilisticexpialidocious", "supercalifragilisticexpialidocious",
	"goodbye", "adiós",
]

var words: [Word] = {
	var words = [Word]()
	for i in 0 ..< wordSource.count / 2 {
		words.append(Word(native: wordSource[i * 2], foreign: wordSource[i * 2 + 1]))
	}
	return words
}()
