//
//  ContentView.swift
//  LanguageWordBuilder
//
//  Created by Jonathan Gurr on 28-09-20.
//

import SwiftUI

let stateChangeCollectionTime: Int = 10

fileprivate func singleLetterButtons(_ index: Int) -> some View {
	return ZStack {
		Button(action: {
			selectLetter(index)
		}) {
			Text(appState.scrambledLetters[index])
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
		}
	}
}

fileprivate func allLetterButtons() -> some View {
	
	return ForEach(0 ..< appState.numberOfColumns, id: \.self) { column in
		VStack {
			Spacer()
			ForEach(
				columnStart(column)
					..<
					columnStart(column + 1),
				id: \.self) { index in
				
				singleLetterButtons(index)
				
				Spacer()
			}
		}
		Spacer()
	}
}

fileprivate func quitButton(alert showingQuitAlert: Binding<Bool>) -> some View {
	return Button(action: {
		showingQuitAlert.wrappedValue = true
	}) {
		Text("<- Quit")
			.fontWeight(.bold)
			.foregroundColor(Color.red)
	}
}

fileprivate func hintButton() -> some View {
	return Button(action: {
		//print("Hint button works!")
		
		if appState.currentWord.answer.hasPrefix(appState.currentAnswer) || appState.currentAnswer.count == 0 {
			if appState.currentAnswer.count < appState.currentWord.answer.count - 1 {
				wordSelectionProbabilities[appState.currentWordIndex].smallFailure()
				let nextCorrectLetterIndex = appState.currentAnswer.count
				let nextCorrectLetter = String(appState.currentWord.answer[nextCorrectLetterIndex])
				let buttonIndex = findButtonIndex(letter: nextCorrectLetter, whenSelected: false)
				selectLetter(buttonIndex)
			}
		} else {
			//adios => "aso"
			wordSelectionProbabilities[appState.currentWordIndex].smallFailure()
			let currentAnswerIndex = appState.currentAnswer.count - 1
			let letterToUnselect = String(appState.currentAnswer.last!)
			let buttonIndex = findButtonIndex(letter: letterToUnselect, whenSelected: true)
			unselectLetter(currentAnswerIndex: currentAnswerIndex, buttonIndex: buttonIndex)
		}
	}) {
		Text("Hint")
			.fontWeight(.bold)
			.foregroundColor(Color.blue)
	}
}

fileprivate func skipButton() -> some View {
	return Button(action: {
		wordSelectionProbabilities[appState.currentWordIndex].largeFailure()
		chooseNewWord()
	}) {
		Text("Skip ->")
			.fontWeight(.bold)
			.foregroundColor(Color.orange)
	}
}

fileprivate func bottomButtons(alert showingQuitAlert: Binding<Bool>) -> some View {
	return HStack {
		Spacer()
		quitButton(alert: showingQuitAlert)
		Spacer()
		hintButton()
		Spacer()
		skipButton()
		Spacer()
	}
}

fileprivate func heading() -> some View {
	return VStack {
		Text(appState.currentWord.questionDescription)
			.font(.title)
		Text("Score: \(appState.score)")
			.padding()
	}
}

struct ContentView: View {
	
	init() {
		addAppStateListener(appState.$numberOfColumns, listenerType: .frontEnd)
		addAppStateListener(appState.$isSelected, listenerType: .frontEnd)
		addAppStateListener(appState.$wordSource, listenerType: .frontEnd)
		addAppStateListener(appState.$wordSourceWasSelected, listenerType: .frontEnd)
	}
	
	@State var version = 1
	@State var showingQuitAlert = false
	
	func refresh() {
		version += 1
		print("new version is \(version)")
	}
	
	fileprivate func mainContent() -> some View {
		VStack {
			
			Spacer()
			heading()
			
			HStack {
				Spacer()
					.alert(isPresented: $showingQuitAlert) {
						Alert(title: Text("Are you sure you want to quit?"), message: Text("All progress will be lost!"), primaryButton: .cancel(Text("No")), secondaryButton: .default(Text("Yes")) {
								quit()
						})
					}
				allLetterButtons()
			}
			
			Spacer()
			
			Text(appState.currentAnswer)
				.font(.title)
				.frame(minHeight: 32)
			
			Spacer()
			
			bottomButtons(alert: $showingQuitAlert)
			Spacer()
		}
	}
	
	fileprivate func startingView() -> some View {
		VStack {
			Text("What language would you like to learn today?")
			HStack {
				Button("Spanish") {
					appState.wordSource = spanishWordSource
					chooseNewWord()
					appState.wordSourceWasSelected = true
					print("tapped Spanish")
				}
				Button("Tagalog") {
					appState.wordSource = tagalogWordSource
					chooseNewWord()
					appState.wordSourceWasSelected = true
					
					print("tapped Tagalog")
				}
			}
		}
	}
	
	var body: some View {
		ForEach(version ..< version + 1, id: \.self) { _ in
			ZStack {
				if !appState.wordSourceWasSelected {
					startingView()
				} else {
					mainContent()
				}
			}
			.onReceive(
				appState.subject
					.filter({ $0 == .frontEnd })
					.collect(.byTime(RunLoop.main, .milliseconds(stateChangeCollectionTime)))
			) { _ in
				print("onReceive")
				refresh()
			}
		}
	}
	
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}
