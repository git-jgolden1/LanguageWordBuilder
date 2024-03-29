//
//  LanguageWordBuilderApp.swift
//  LanguageWordBuilder
//
//  Created by Jonathan Gurr on 28-09-20.
//

import SwiftUI

@main
struct LanguageWordBuilderApp: App {
	
	let persistenceController = PersistenceController.shared
	
	
	var body: some Scene {
		WindowGroup {
			ContentView()
				.environment(\.managedObjectContext, persistenceController.container.viewContext)
		}
	}
	init() {
		loadModel()
	}
}

struct LanguageWordBuilderApp_Previews: PreviewProvider {
	static var previews: some View {
		/*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
	}
}
