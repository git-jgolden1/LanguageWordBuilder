//
//  ContentView.swift
//  LanguageWordBuilder
//
//  Created by Jonathan Gurr on 28-09-20.
//
/* Goals for 11-16-20:
-Button color change for selected buttons
-Multiple letters in buttons if word length exceeds 10
*/
import SwiftUI
import CoreData

let numberOfColumns = 3

struct ContentView: View {
	@State var wordIndex: Int = 0
	@State var scrambledWords: [Word] = [words[0]]
	@State var scrambledLetters: [String] = []
	@State var isSelected: [Bool] = []
	@State var currentAnswer = ""
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
	
	var body: some View {
		VStack {
			Spacer()
			Text(scrambledWords[wordIndex].foreign)
				.font(.title)
			Spacer()
			HStack {
				Spacer()
				ForEach(0 ..< numberOfColumns) { column in
					VStack {
						Spacer()
						ForEach(
							columnStart(column)
								..<
								columnStart(column + 1),
							id: \.self) { index in
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
								}
							}) {
								Text(scrambledLetters[index])
									.fontWeight(.bold)
									.font(.subheadline)
									.padding(12)
									.background(Color.purple)
									.cornerRadius(30)
									.foregroundColor(.white)
									.padding(12)
									.overlay(
										RoundedRectangle(cornerRadius: 30)
											.stroke(Color.purple, lineWidth: 5)
									)
							} //end of button UI
							Spacer()
							} //end of inner ForEach
					} //end of VStack
					Spacer()
				} //end of outer ForEach
			} //end of column-HStack
			Spacer()
			Text(currentAnswer)
			Spacer()
		} //end of main VStack
		.onAppear() {
			scrambleWords()
			scrambleLetters()
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
