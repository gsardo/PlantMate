//
//  ContentView.swift
//  PlantMate
//
//  Created by Giuseppe Sardo on 10/6/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            PlantCollectionView()
                .tabItem {
                    Label("Plants", systemImage: "leaf.circle")
                }
        }
    }
}

#Preview {
    ContentView()
}
