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

fileprivate func hintAndSkipButtons() -> some View {
	return HStack {
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
	}
	
	@State var version = 1
	@State var showingWordReportAlert = false

	func refresh() {
		version += 1
		print("new version is \(version)")
	}

	var body: some View {
		ForEach(version ..< version + 1, id: \.self) { _ in
			VStack {

				Spacer()
				heading()
				
				HStack {
					Spacer()
					allLetterButtons()
						.alert(isPresented: $showingWordReportAlert) {
							Alert(title: Text("Good job!"), message: Text("\(words[appState.currentWordIndex].questionDescription) means \(words[appState.currentWordIndex].answer)"), dismissButton: .default(Text("OK! 👍")) {
								appState.showingWordReportAlert = false
								chooseNewWord()
							})
						}
				}
				
				Spacer()
				
				Text(appState.currentAnswer)
					.font(.title)
					.frame(minHeight: 40)
				
				hintAndSkipButtons()
				
			}
		}
		.onReceive(
			appState.subject
				.filter({ $0 == .frontEnd })
				.collect(.byTime(RunLoop.main, .milliseconds(stateChangeCollectionTime)))
		) { _ in
			if appState.showingWordReportAlert != showingWordReportAlert {
				showingWordReportAlert = appState.showingWordReportAlert
			} else {
				refresh()
			}
			print("TopView: view state changed to \(self.version)")
		}
		.onAppear() {
			print("appearing...")
		}
		Spacer()
	}
	
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}

