//
//  Artless_NotesApp.swift
//  Artless Notes
//
//  Created by Md Abir Hossain on 19/2/23.
//

import SwiftUI

@main
struct Artless_NotesApp: App {
    var body: some Scene {
        WindowGroup {
            if #available(iOS 16.0, *) {
                NavigationStack {
                    ContentView()
                }
            } else {
                NavigationView {
                    ContentView()
                }
            }
        }
    }
}
