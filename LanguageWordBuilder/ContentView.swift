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
	
	func scramble() {
		print("scrambled")
		currentAnswer = ""
		var isSelected: [Bool] = []
		var scrambledLetters: [String] = []
		for letter in words[wordIndex].native {
			scrambledLetters.append(String(letter))
			isSelected.append(false)
		}
		self.scrambledLetters = scrambledLetters.shuffled()
		self.isSelected = isSelected
	}
	
	var body: some View {
		HStack {
			VStack {
				Text(words[wordIndex].foreign)
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
							if currentAnswer == words[wordIndex].native {
								wordIndex += 1
								scramble()
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
			scramble()
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
			ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
