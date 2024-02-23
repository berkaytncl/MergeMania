//
//  Game2048App.swift
//  Game2048
//
//  Created by Berkay Tuncel on 23.02.2024.
//

import SwiftUI

@main
struct Game2048App: App {
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color(.accent))]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color(.accent))]
        UINavigationBar.appearance().tintColor = UIColor(Color(.accent))
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
            }
        }
    }
}
