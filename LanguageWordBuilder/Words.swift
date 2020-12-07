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
