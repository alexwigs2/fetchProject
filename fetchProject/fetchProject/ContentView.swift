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
            LinearGradient(gradient: Gradient(colors: [Color(.init(red: 123/255.0, green: 73/255.0, blue: 13/255.0, alpha: 1.0)).opacity(0.3), Color(.gray)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            NavigationView {
                ScrollView {
                    RecipeList(recipes: recipesVM.recipes)
                }
                .background(Color.clear)
                
                .navigationTitle("My Recipes")
            }
            .background(Color.clear)
            
            //reload data as view will appear
//            .onAppear(perform: recipesVM.getData)
            .navigationViewStyle(.stack)
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
