//
//  BusinessLogic.swift
//  LanguageWordBuilder
//
//  Created by Jonathan Gurr on 12/31/20.
//

import Foundation

func resetAnswer() {
	appState.isSelected = appState.isSelected.map {_ in false}
	currentAnswer = ""
}

func scrambleLetters() {
	//		print("scrambling letters from \(currentWord.answer)")
	var wordIsNotScrambled = true
	
	while wordIsNotScrambled {
		currentAnswer = ""
		scrambledLetters = []
		appState.isSelected = []
		for letter in currentWord.answer {
			scrambledLetters.append(String(letter))
			appState.isSelected.append(false)
		}
		scrambledLetters = scrambledLetters.shuffled()
		wordIsNotScrambled = currentWord.answer == scrambledLetters.joined()
	}
	//		print("scrambling letters to \(scrambledLetters.joined())")
}

func updateColumns() {
	let dividing = Double(scrambledLetters.count) / 7
	let extractedCeil = Int(ceil(dividing))
	appState.numberOfColumns = extractedCeil
	if scrambledLetters.count > 3 && appState.numberOfColumns == 1 {
		appState.numberOfColumns = 2
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

func selectLetter(_ absoluteIndex: Int) {
	if appState.isSelected[absoluteIndex] {
		wordSelectionProbabilities[currentWordIndex].smallFailure()
		resetAnswer()
	} else {
		appState.isSelected[absoluteIndex] = true
		currentAnswer += scrambledLetters[absoluteIndex]
	}
	if currentAnswer == currentWord.answer {
		score += 1
		chooseNewWord()
	}
}

func unselectLetter(currentAnswerIndex: Int, buttonIndex: Int) {
	assert(currentAnswerIndex >= 0)
	appState.isSelected[buttonIndex] = false
	let removeIndex: String.Index = currentAnswer.index(currentAnswer.startIndex, offsetBy: currentAnswerIndex)
	currentAnswer.remove(at: removeIndex)
}

func columnStart(_ column: Int) -> Int {
	//		print("\(numberOfColumns) = number of columns")
	return scrambledLetters.count * column / appState.numberOfColumns
}

func findButtonIndex(letter: String, whenSelected: Bool) -> Int {
	var index: Int? = nil
	for i in appState.isSelected.indices {
		if scrambledLetters[i] == letter && appState.isSelected[i] == whenSelected {
			index = i
			break
		}
	}
	assert(index != nil)
	return index!
}
