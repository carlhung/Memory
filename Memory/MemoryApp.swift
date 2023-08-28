//
//  MemoryApp.swift
//  Memory
//
//  Created by Carl Hung on 25/08/2023.
//

import SwiftUI

@main
struct MemoryApp: App {
    
//    @State
//    var textInput: String = ""
    
//    @State private var path = NavigationPath()
    
    var body: some Scene {
        WindowGroup {
            HomeView(model: HomeViewModel())
            //            NavigationStack {
            //                NavigationLink(value: "NewView") {
            //                    Text("Show NewView")
            //                }
            //                .navigationDestination(for: String.self) { view in
            //                    if view == "NewView" {
            //                        Text("This is NewView")
            //                    }
            //                }
            //            }
            
            
//            NavigationStack(path: $path) {
//                Button {
//                    path.append("NewView")
//                } label: {
//                    Text("Show NewView")
//                }
//                .navigationDestination(for: String.self) { view in
//                    if view == "NewView" {
//                        Text("This is NewView")
//                    }
//                }
//            }
        }
    }
}


//struct ResultView: View {
//    var choice: String
//
//    var body: some View {
//        Text("You chose \(choice)")
//    }
//}
//
//NavigationView {
//    VStack(spacing: 30) {
//        Text("You're going to flip a coin – do you want to choose heads or tails?")
//
//        NavigationLink(destination: ResultView(choice: "Heads")) {
//            Text("Choose Heads")
//        }
//
//        NavigationLink(destination: ResultView(choice: "Tails")) {
//            Text("Choose Tails")
//        }
//    }
//    .navigationTitle("Navigation")
//}
