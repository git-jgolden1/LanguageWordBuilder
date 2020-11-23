//
//  ContentView.swift
//  LanguageWordBuilder
//
//  Created by Jonathan Gurr on 28-09-20.
//
/* Goals for 11-22-20:
-Support importing native and foreign word arrays
*/

import SwiftUI
import CoreData

struct ContentView: View {
	@State var wordIndex: Int = 0
	@State var scrambledWords: [Word] = [words[0]]
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
	
	func scrambleWords() {
		print("scrambling words")
		self.scrambledWords = words.shuffled()
		//		scrambledWords = words
	}
	
	func scrambleLetters() {
		print("scrambling letters from \(scrambledWords[wordIndex].native)")
		var wordIsNotScrambled = true
		var isSelected: [Bool] = []
		var scrambledLetters: [String] = []
		while wordIsNotScrambled {
			currentAnswer = ""
			scrambledLetters = []
			isSelected = []
			for letter in scrambledWords[wordIndex].native {
				scrambledLetters.append(String(letter))
				isSelected.append(false)
			}
			scrambledLetters = scrambledLetters.shuffled()
			wordIsNotScrambled = scrambledWords[wordIndex].native == scrambledLetters.joined()
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
	
	var body: some View {
		VStack {
			Spacer()
			Text(scrambledWords[wordIndex].foreign)
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
									if currentAnswer == scrambledWords[wordIndex].native {
										wordIndex += 1
										if wordIndex >= scrambledWords.count {
											wordIndex = 0
											scrambleWords()
										}
										scrambleLetters()
										updateColumns()
									}
								}) {
									Text(scrambledLetters[index])
										.fontWeight(.bold)
										.font(.headline)
										.padding(6)
										.background(isSelected[index] ? Color.green : Color.black)
										.cornerRadius(24)
										.foregroundColor(.white)
										.padding(6)
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
			Spacer()
			Button(action: {
				print("Skip button works!")
				if wordIndex < words.count - 1 {
					wordIndex += 1
					scrambleLetters()
					updateColumns()
				} else {
					wordIndex = 0
					scrambleWords() //not completely necessary, only if you want words in different order in each cycle
					scrambleLetters()
					updateColumns()
				}
			}) {
				Text("Skip ->")
					.fontWeight(.bold)
					.foregroundColor(Color.orange)
			}
			Spacer()
		} //end of main VStack
		.onAppear() {
			scrambleWords()
			scrambleLetters()
			updateColumns()
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
