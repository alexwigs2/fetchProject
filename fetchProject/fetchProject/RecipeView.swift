//
//  RecipeView.swift
//  fetchProject
//
//  Created by Alex Wigsmoen on 4/5/25.
//

import SwiftUI

struct RecipeView: View {
    var recipe: Recipe
    
    var body: some View {
        ScrollView {
            AsyncImage(url: URL(string: recipe.photo_url_small)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
            } placeholder: {
                Image.init(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100, alignment: .center)
                    .foregroundColor(.white.opacity(0.7))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(height: 300)
   
            .background(LinearGradient(gradient: Gradient(colors: [Color(.gray).opacity(0.3), Color(.gray)]), startPoint: .top, endPoint: .bottom))
            
            VStack(spacing: 30) {
                Text(recipe.name)
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                
                VStack(alignment: .leading, spacing: 30) {
                    if !recipe.source_url.isEmpty {
                        Text(recipe.source_url)
                    }
                    
                    if !recipe.source_url.isEmpty {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Website")
                                .font(.headline)
                            
                            Text(recipe.source_url)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal)
        }

        .background(LinearGradient(gradient: Gradient(colors: [Color(.init(red: 123/255.0, green: 73/255.0, blue: 13/255.0, alpha: 1.0)).opacity(0.3), Color(.gray)]), startPoint: .top, endPoint: .bottom))
        .ignoresSafeArea(.container, edges: .top)
    }
}

//struct RecipeView_Previews: PreviewProvider {
//    static var previews: some View {
//       RecipeView(recipe: Recipe.all[0])
//    }
//}
