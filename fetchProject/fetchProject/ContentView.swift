//
//  ContentView.swift
//  fetchProject
//
//  Created by Alex Wigsmoen on 4/5/25.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var recipesVM = RecipesViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                NavigationView {
                    ScrollView {
                        RecipeList(recipes: recipesVM.recipes)
                    }
                    .navigationTitle("My Recipes")
                }
                .navigationViewStyle(.stack)
            }
            
            if !recipesVM.doneLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(1.5)
                    .padding(.leading)
            }
        }
        .onAppear {
            self.loadData()
        }
    }
    
    func loadData() {
        DispatchQueue.main.async {
            recipesVM.setData()
        }
    }
}
