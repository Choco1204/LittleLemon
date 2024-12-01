//
//  Home.swift
//  Little Lemon
//
//  Created by Mimi_Son on 01/12/24.
//

import SwiftUI

struct Home: View {
    let persistence = PersistenceController.shared
    
    var body: some View {
        TabView {
            HomeView()
                .environment(\.managedObjectContext, persistence.container.viewContext)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            Menu()
                .environment(\.managedObjectContext, persistence.container.viewContext)

                .tabItem {
                Label("Menu", systemImage: "list.dash")
            }
            UserProfile() .tabItem {
                Label("Profile", systemImage: "square.and.pencil")
            }

        }
        .navigationBarBackButtonHidden(true)
    }
}

//#Preview {
//    Home()
//}
