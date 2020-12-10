//
//  ContentView.swift
//  LanguageWordBuilder
//
//  Created by Jonathan Gurr on 28-09-20.
//


import SwiftUI
import CoreData

struct ContentView: View {
	@State var currentWord = words[0]
	@State var scrambledLetters: [String] = []
	@State var isSelected: [Bool] = []
	@State var numberOfColumns: Int = 1
	@State var currentAnswer = ""
	@State var version = 1
	init() {
//		print("ContentView.init")
	}
	
	func resetAnswer() {
		isSelected = isSelected.map {_ in false}
		currentAnswer = ""
	}
	
	func scrambleLetters() {
//		print("scrambling letters from \(currentWord.answer)")
		var wordIsNotScrambled = true
		var isSelected: [Bool] = []
		var scrambledLetters: [String] = []
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
		self.isSelected = isSelected
		self.scrambledLetters = scrambledLetters
//		print("scrambling letters to \(scrambledLetters.joined())")
	}
	
	func updateColumns() {
		let dividing: Double = Double(scrambledLetters.count) / 7
		let extractedCeil: Double = ceil(dividing)
		numberOfColumns = Int(extractedCeil)
		if scrambledLetters.count > 3 && numberOfColumns == 1 {
			numberOfColumns = 2
		}
		refresh()
	}
	
	func refresh() {
		version += 1
	}
	
	func chooseNewWord() {
		currentWord = words.randomElement() ?? Word(question: "insecto", answer: "bug", questionDescription: "insecto", answerDescription: "a problem in the program, or an insect")
		if Bool.random() {
			currentWord = currentWord.switchOrder()
			print("order switched!")
		}
		scrambleLetters()
		updateColumns()
	}
	
	func selectLetter(_ absoluteIndex: Int) {
		if isSelected[absoluteIndex] {
			resetAnswer()
		} else {
			isSelected[absoluteIndex] = true
			currentAnswer += scrambledLetters[absoluteIndex]
		}
		if currentAnswer == currentWord.answer {
			chooseNewWord()
		}
	}
	
	func unselectLetter(_ absoluteIndex: Int) {
		assert(absoluteIndex >= 0)
		isSelected[absoluteIndex] = false
		currentAnswer.remove(at: currentAnswer.index(currentAnswer.startIndex, offsetBy: absoluteIndex))
	}
	
	var body: some View {
		VStack {
			Spacer()
			Text(currentWord.questionDescription)
				.font(.title)
			Spacer()
			HStack {
				Spacer()
				ForEach(0 ..< numberOfColumns, id: \.self) { column in
					VStack {
						Spacer()
						ForEach(
							columnStart(column)
								..<
								columnStart(column + 1),
							id: \.self) { index in
							ZStack {
								Button(action: {
									selectLetter(index)
								}) {
									Text(scrambledLetters[index])
										.fontWeight(.bold)
										.font(.title)
										.padding(10)
										.background(isSelected[index] ? Color.green : Color.black)
										.cornerRadius(24)
										.foregroundColor(.white)
										.padding(10)
										.overlay(
											RoundedRectangle(cornerRadius: 24)
												.stroke(Color.black, lineWidth: 3)
										)
								} //end of button UI
								//								if isSelected[index] {
								//									Text("X")
								//										.font(.largeTitle)
								//								}
							} //end of ZStack
							Spacer()
						} //end of inner ForEach
					} //end of VStack
					Spacer()
				} //end of outer ForEach
			} //end of column-HStack
			Spacer()
			Text(currentAnswer)
				.font(.title)
				.frame(minHeight: 40)
			HStack {
				Spacer()
				Button(action: {
//					print("Hint button works!")
					var index: Int? = nil
					if currentWord.answer.hasPrefix(currentAnswer) || currentAnswer.count == 0 {
						let nextCorrectLetterIndex = currentAnswer.count
						let nextCorrectLetter = String(currentWord.answer[nextCorrectLetterIndex])
						for i in isSelected.indices {
							if scrambledLetters[i] == nextCorrectLetter && !isSelected[i] {
								index = i
								break
							}
						}
						assert(index != nil)
						//excelentemente => "excelen"
						selectLetter(index!)
					} else {
						//adios => "aso"
						index = currentAnswer.count - 1
						unselectLetter(index!)
					}
				}) {
					Text("Hint")
						.fontWeight(.bold)
						.foregroundColor(Color.blue)
				}
				Spacer()
				Button(action: {
					chooseNewWord()
				}) {
					Text("Skip ->")
						.fontWeight(.bold)
						.foregroundColor(Color.orange)
				}
				Spacer()
			} //end of HStack for bottom buttons
		} //end of main VStack
		.onAppear() {
			chooseNewWord()
		}
		Spacer()
	}
	func columnStart(_ column: Int) -> Int {
		return scrambledLetters.count * column / numberOfColumns
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}
