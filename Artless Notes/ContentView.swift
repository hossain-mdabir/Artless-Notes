//
//  ContentView.swift
//  Plain Notes
//
//  Created by Md Abir Hossain on 28/1/23.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack {
            HomeView(title: "", description: "")
        }
//        .navigationTitle("Plain Notes")
//        .navigationBarTitleDisplayMode(.automatic)
//        .navigationViewStyle(.stack)
        .navigationBarHidden(true)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
