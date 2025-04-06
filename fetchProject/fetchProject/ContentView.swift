//
//  ContentView.swift
//  fetchProject
//
//  Created by Alex Wigsmoen on 4/5/25.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var recipesVM = RecipesViewModel()
    @State private var hideButton = false
    
    var body: some View {
        ZStack {
            VStack {
                // add button to refresh data
                NavigationView {
                    ScrollView {
                        RecipeList(recipes: recipesVM.recipes, hideButton: $hideButton)
                    }
                    .navigationTitle("My Recipes")
                }
                .navigationViewStyle(.stack)
                
                if !self.hideButton {
                    Button ( action : {
                        recipesVM.getData()
                    }){
                        Text("Refresh")
                            .font(.headline)
                            .foregroundColor(Color(.black))
                        // set the width of the button
                            .frame(maxWidth: .infinity)
                            .frame(height: 48.0)
                        
                    }
                    .background(Color.clear)
                    .cornerRadius(6.0)
                    .padding(.top, 10.0)
                    .frame(height: 48.0)
                    .padding(.horizontal, 20.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6.0)
                            .stroke(Color.black, lineWidth: 2) // Border around the button
                    )
                }
            }
        }
    }
    
    init() {
        recipesVM.getData()
        print("hit new data \(recipesVM.getData())")
    }
}

//#Preview {
//    ContentView()
//}
