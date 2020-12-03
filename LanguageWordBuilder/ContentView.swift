//
//  ContentView.swift
//  LanguageWordBuilder
//
//  Created by Jonathan Gurr on 28-09-20.
//

import SwiftUI
import CoreData

struct ContentView: View {
//	@State var wordIndex: Int = 0
	@State var currentWord = words[0]
	@State var scrambledLetters: [String] = []
	@State var isSelected: [Bool] = []
	@State var numberOfColumns: Int = 1
	@State var currentAnswer = ""
	@State var version = 1
	init() {
		print("ContentView.init")
	}
	
	func resetAnswer() {
		isSelected = isSelected.map {_ in false}
		currentAnswer = ""
	}
	
	func scrambleLetters() {
		print("scrambling letters from \(currentWord.native)")
		var wordIsNotScrambled = true
		var isSelected: [Bool] = []
		var scrambledLetters: [String] = []
		while wordIsNotScrambled {
			currentAnswer = ""
			scrambledLetters = []
			isSelected = []
			for letter in currentWord.native {
				scrambledLetters.append(String(letter))
				isSelected.append(false)
			}
			scrambledLetters = scrambledLetters.shuffled()
			wordIsNotScrambled = currentWord.native == scrambledLetters.joined()
		}
		self.isSelected = isSelected
		self.scrambledLetters = scrambledLetters
		print("scrambling letters to \(scrambledLetters.joined())")
	}
	
	func updateColumns() {
		let dividing: Double = Double(scrambledLetters.count) / 7
		let extractedCeil: Double = ceil(dividing)
		numberOfColumns = Int(extractedCeil)
		refresh()
	}
	
	func refresh() {
		version += 1
	}
	
	func chooseNewWord() {
		print("choosing new word")
		currentWord = words.randomElement() ?? Word(foreign: "insecto", native: "bug", foreignDescription: "insecto", nativeDescription: "a problem in the program, or an insect")
		if Bool.random() {
			currentWord = currentWord.switchOrder()
		}
		scrambleLetters()
		updateColumns()
	}
	
	var body: some View {
		VStack {
			Spacer()
			Text(currentWord.foreignDescription)
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
									if isSelected[index] {
										resetAnswer()
									} else {
										isSelected[index] = true
										currentAnswer += scrambledLetters[index]
									}
									if currentAnswer == currentWord.native {
										chooseNewWord()
									}
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
			Spacer()
			Button(action: {
				print("Skip button works!")
				chooseNewWord()
			}) {
				Text("Skip ->")
					.fontWeight(.bold)
					.foregroundColor(Color.orange)
			}
			Spacer()
		} //end of main VStack
		.onAppear() {
			chooseNewWord()
		}
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
