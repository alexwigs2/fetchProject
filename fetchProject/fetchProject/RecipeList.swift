//
//  RecipeList.swift
//  fetchProject
//
//  Created by Alex Wigsmoen on 4/5/25.
//

import Foundation
import SwiftUI

struct RecipeList: View {
    var recipes: [Recipe]
    @ObservedObject var recipesVM = RecipesViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("\(recipes.count) \(recipes.count > 1 ? "recipes" : "recipe")")
                        .font(.headline)
                        .fontWeight(.medium)
                        .opacity(0.7)
                    
                    Spacer()
                    
                    Button ( action : {
                        recipesVM.getData()
                    }){
                        Text("Refresh Recipes")
                            .font(.headline)
                            .foregroundColor(Color(.black))
                            .frame(maxWidth: .infinity)
                            .frame(height: 30.0)
                        
                    }
                    .background(Color.black.opacity(0.2))
                    .cornerRadius(6.0)
                    .frame(width: 150, height: 30)
                }
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 15)], spacing: 15) {
                    ForEach(recipes) { recipe in
                        NavigationLink(destination: RecipeView(recipe: recipe)) {
                            RecipeCard(recipe: recipe)
                        }
                    }
                }
                .padding(.top)
            }
            .padding(.horizontal)
            
        }
    }
}
