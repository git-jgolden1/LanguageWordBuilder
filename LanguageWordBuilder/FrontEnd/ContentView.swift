//
//  ContentView.swift
//  LanguageWordBuilder
//
//  Created by Jonathan Gurr on 28-09-20.
//

import SwiftUI

let stateChangeCollectionTime: Int = 10

struct ContentView: View {
	
	init() {
		addAppStateListener(appState.$numberOfColumns)
		addAppStateListener(appState.$isSelected)
	}
	
	@State var version = 1
	
	func refresh() {
		version += 1
		print("new version is \(version)")
	}
	

	
	var body: some View {
		ForEach(version ..< version + 1, id: \.self) { _ in
			VStack {
				Spacer()
				Text(currentWord.questionDescription)
					.font(.title)
				Spacer()
				Text("Score: \(score)")
				HStack {
					Spacer()
					ForEach(0 ..< appState.numberOfColumns, id: \.self) { column in
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
											.background(appState.isSelected[index] ? Color.green : Color.black)
											.cornerRadius(24)
											.foregroundColor(.white)
											.padding(10)
											.overlay(
												RoundedRectangle(cornerRadius: 24)
													.stroke(Color.black, lineWidth: 3)
											)
									} //end of button UI
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
						//print("Hint button works!")
						
						if currentWord.answer.hasPrefix(currentAnswer) || currentAnswer.count == 0 {
							if currentAnswer.count < currentWord.answer.count - 1 {
								wordSelectionProbabilities[currentWordIndex].smallFailure()
								let nextCorrectLetterIndex = currentAnswer.count
								let nextCorrectLetter = String(currentWord.answer[nextCorrectLetterIndex])
								let buttonIndex = findButtonIndex(letter: nextCorrectLetter, whenSelected: false)
								selectLetter(buttonIndex)
							}
						} else {
							//adios => "aso"
							wordSelectionProbabilities[currentWordIndex].smallFailure()
							let currentAnswerIndex = currentAnswer.count - 1
							let letterToUnselect = String(currentAnswer.last!)
							let buttonIndex = findButtonIndex(letter: letterToUnselect, whenSelected: true)
							unselectLetter(currentAnswerIndex: currentAnswerIndex, buttonIndex: buttonIndex)
						}
					}) {
						Text("Hint")
							.fontWeight(.bold)
							.foregroundColor(Color.blue)
					}
					Spacer()
					Button(action: {
						wordSelectionProbabilities[currentWordIndex].largeFailure()
						chooseNewWord()
					}) {
						Text("Skip ->")
							.fontWeight(.bold)
							.foregroundColor(Color.orange)
					}
					Spacer()
				} //end of HStack for bottom buttons
			} //end of main VStack
		}
		.onReceive(
			appState.subject
				.filter({ $0 == .mainView })
				.collect(.byTime(RunLoop.main, .milliseconds(stateChangeCollectionTime)))
		) { x in
			refresh()
			print("TopView: view state changed to \(self.version)")
		}
		.onAppear() {
			print("appearing...")
		}
		Spacer()
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
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}
