//
//  MemoryApp.swift
//  Memory
//
//  Created by Carl Hung on 25/08/2023.
//

import SwiftUI

@main
struct MemoryApp: App {
    
    var body: some Scene {
        WindowGroup {
            HomeView(model: HomeViewModel())
        }
    }
}
