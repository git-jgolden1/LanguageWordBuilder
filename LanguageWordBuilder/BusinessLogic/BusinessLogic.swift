//
//  BusinessLogic.swift
//  LanguageWordBuilder
//
//  Created by Jonathan Gurr on 12/31/20.
//

import Foundation

func resetAnswer() {
	isSelected = isSelected.map {_ in false}
	currentAnswer = ""
}

func scrambleLetters() {
	//		print("scrambling letters from \(currentWord.answer)")
	var wordIsNotScrambled = true
	
	while wordIsNotScrambled {
		currentAnswer = ""
		scrambledLetters = []
		isSelected = []
		for letter in currentWord.answer {
			scrambledLetters.append(String(letter))
			isSelected.append(false)
		}
		scrambledLetters = scrambledLetters.shuffled()
		wordIsNotScrambled = currentWord.answer == scrambledLetters.joined()
	}
	//		print("scrambling letters to \(scrambledLetters.joined())")
}

func updateColumns() {
	let dividing = Double(scrambledLetters.count) / 7
	let extractedCeil = Int(ceil(dividing))
	numberOfColumns = extractedCeil
	if scrambledLetters.count > 3 && numberOfColumns == 1 {
		numberOfColumns = 2
	}
}

func chooseNewWord() {
	let previousWordAnswer = currentWord.answer
	while previousWordAnswer == currentWord.answer || !wordSelectionProbabilities[currentWordIndex].shouldSelect() {
		var loopCount = 1
		currentWordIndex = Int.random(in: 0 ..< words.count)
		currentWord = words[currentWordIndex]
		loopCount += 1
		assert(loopCount < 10)
	}
	
	if Bool.random() {
		currentWord = currentWord.switchOrder()
		//			print("order switched!")
	}
	
	wordSelectionProbabilities[currentWordIndex].success()
	scrambleLetters()
	updateColumns()
	print("New word chosen. Scrambled letters = \(scrambledLetters)")
}

