//
//  ContentView.swift
//  LanguageWordBuilder
//
//  Created by Jonathan Gurr on 28-09-20.
//

import SwiftUI
import CoreData


struct ContentView: View {
	@State var wordIndex: Int = 0
	@State var scrambledWords: [Word] = []
	@State var scrambledLetters: [String] = []
	@State var isSelected: [Bool] = []
	@State var currentAnswer = ""
	let test = "1,2,3,4"
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
			if wordIsNotScrambled {
				print("letters not scrambled")
			}
		}
		self.isSelected = isSelected
		self.scrambledLetters = scrambledLetters
		print("scrambling letters to \(scrambledLetters.joined())")
	}
	
	var body: some View {
		HStack {
			VStack {
//				Text(scrambledWords[wordIndex].foreign)
				Spacer()
				VStack {
					ForEach(0..<scrambledLetters.count, id: \.self) { index in
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
						}
					}
					Text(currentAnswer)
				}
				Spacer()
			}
		}
		.onAppear() {
			scrambleWords()
			scrambleLetters()
		}
	}
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
			ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
