//
//  BusinessLogic.swift
//  LanguageWordBuilder
//
//  Created by Jonathan Gurr on 12/31/20.
//

import Foundation

func resetAnswer() {
	appState.isSelected = appState.isSelected.map {_ in false}
	appState.currentAnswer = ""
}

func scrambleLetters() {
	var wordIsNotScrambled = true
	
	while wordIsNotScrambled {
		appState.currentAnswer = ""
		appState.scrambledLetters = []
		appState.isSelected = []
		for letter in appState.currentWord.answer {
			appState.scrambledLetters.append(String(letter))
			appState.isSelected.append(false)
		}
		appState.scrambledLetters = appState.scrambledLetters.shuffled()
		wordIsNotScrambled = appState.currentWord.answer == appState.scrambledLetters.joined()
	}
}

func updateColumns() {
	let dividing = Double(appState.scrambledLetters.count) / 6
	let extractedCeil = Int(ceil(dividing))
	appState.numberOfColumns = extractedCeil
	if appState.scrambledLetters.count > 3 && appState.numberOfColumns == 1 {
		appState.numberOfColumns = 2
	}
}

func chooseNewWord() {
	let previousWordAnswer = appState.currentWord.answer
	while previousWordAnswer == appState.currentWord.answer || !wordSelectionProbabilities[appState.currentWordIndex].shouldSelect() {
		var loopCount = 1
		appState.currentWordIndex = Int.random(in: 0 ..< words.count)
		loopCount += 1
		assert(loopCount < 10)
	}
	
	if Bool.random() {
		appState.switchOrder()
	}
	
	wordSelectionProbabilities[appState.currentWordIndex].success()
	scrambleLetters()
	updateColumns()
	print("New word chosen. Scrambled letters = \(appState.scrambledLetters)")
}

func selectLetter(_ absoluteIndex: Int) {
	if appState.isSelected[absoluteIndex] {
		wordSelectionProbabilities[appState.currentWordIndex].smallFailure()
		resetAnswer()
	} else {
		appState.isSelected[absoluteIndex] = true
		appState.currentAnswer += appState.scrambledLetters[absoluteIndex]
	}
	if appState.currentAnswer == appState.currentWord.answer {
		appState.score += 1
		// appState.showingWordReportAlert = true
		chooseNewWord()
	}
}

func unselectLetter(currentAnswerIndex: Int, buttonIndex: Int) {
	assert(currentAnswerIndex >= 0)
	appState.isSelected[buttonIndex] = false
	let removeIndex: String.Index = appState.currentAnswer.index(appState.currentAnswer.startIndex, offsetBy: currentAnswerIndex)
	appState.currentAnswer.remove(at: removeIndex)
}

func columnStart(_ column: Int) -> Int {
	//		print("\(numberOfColumns) = number of columns")
	return appState.scrambledLetters.count * column / appState.numberOfColumns
}

func findButtonIndex(letter: String, whenSelected: Bool) -> Int {
	var index: Int? = nil
	for i in appState.isSelected.indices {
		if appState.scrambledLetters[i] == letter && appState.isSelected[i] == whenSelected {
			index = i
			break
		}
	}
	return index!
}

func quit() {
	appState.reset()
}

