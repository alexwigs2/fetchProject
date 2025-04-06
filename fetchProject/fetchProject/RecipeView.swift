//
//  RecipeView.swift
//  fetchProject
//
//  Created by Alex Wigsmoen on 4/5/25.
//

import SwiftUI

struct RecipeView: View {
    var recipe: Recipe
    
    @Environment(\.dismiss) private var dismiss
    @Binding var hideButton: Bool
    
    var body: some View {
        ScrollView {
            AsyncImage(url: URL(string: recipe.photo_url_large)) { image in
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
            VStack(spacing: 30) {
                Text(recipe.name)
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.top, 40)
                
                VStack(alignment: .leading, spacing: 30) {
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Website")
                            .font(.headline)
                        
                        Text(recipe.source_url)
                    }
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Website")
                            .font(.headline)
                        
                        Text(recipe.source_url)
                    }
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal)
        }
        .ignoresSafeArea(.container, edges: .top)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.dismiss()
                    self.hideButton = false
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }
        }
    }
}

//struct RecipeView_Previews: PreviewProvider {
//    static var previews: some View {
//       RecipeView(recipe: Recipe.all[0])
//    }
//}
