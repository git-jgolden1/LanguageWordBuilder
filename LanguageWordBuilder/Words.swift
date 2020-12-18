//
//  Words.swift
//  LanguageWordBuilder
//
//  Created by Jonathan Gurr on 05-10-20.
//

import Foundation

struct Word: Hashable {
	let question: String
	let answer: String
	let questionDescription: String
	let answerDescription: String
	func switchOrder() -> Word {
		let newQuestion = self.answer
		let newAnswer = self.question
		let newQuestionDescription = self.answerDescription
		let newAnswerDescription = self.questionDescription
		return Word(question: newQuestion, answer: newAnswer, questionDescription: newQuestionDescription, answerDescription: newAnswerDescription)
	}
}

let wordSource = spanishWordSource

var words: [Word] = stride(from: 0, to: wordSource.count - 1, by: 2).map {
	let foreignDescription = wordSource[$0].count > 1 ? wordSource[$0][1] : wordSource[$0][0]
	let nativeDescription = wordSource[$0 + 1].count > 1 ? wordSource[$0 + 1][1] : wordSource[$0 + 1][0]
	return Word(question: wordSource[$0][0], answer: wordSource[$0 + 1][0], questionDescription: foreignDescription, answerDescription: nativeDescription)
}

class WordSelectionProbability {
	private static let successRatio = 0.5
	private static let smallFailureRatio = 1.25
	private static let largeFailureRatio = pow(smallFailureRatio, 3)
	var value: Double
	func printValue() {
		print("\(words[currentWordIndex].question) :  \(value)")
	}
	
	func success() {
		printValue()
		value *= WordSelectionProbability.successRatio
		printValue()
	}
	
	func smallFailure() {
		printValue()
		value *= WordSelectionProbability.smallFailureRatio
		printValue()
	}
	
	func largeFailure() {
		printValue()
		value *= WordSelectionProbability.largeFailureRatio
		printValue()
	}
	
	func shouldSelect() -> Bool {
		return value >= Double.random(in: 0 ..< 1)
	}
	
	init(_ value: Double) {
		self.value = value
	}
}

var wordSelectionProbabilities = makeWordSelectionProbabilities()
func makeWordSelectionProbabilities() -> [WordSelectionProbability] {
	var a: [WordSelectionProbability] = []
	for _ in words.indices {
		a.append(WordSelectionProbability(1.0))
	}
	return a
}
