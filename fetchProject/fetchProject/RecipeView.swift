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
    @State private var loadedImage: Image? = nil
    
    var body: some View {
        ScrollView {
            if let image = loadedImage {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 300)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100, alignment: .center)
                    .foregroundColor(.white.opacity(0.7))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                .frame(height: 300)
            }
            
            VStack(spacing: 30) {
                Text(recipe.name)
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.top, 45)
                
                VStack(alignment: .leading, spacing: 30) {
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Cuisine")
                            .font(.headline)
                        
                        Text(recipe.cuisine)
                    }
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Website")
                            .font(.custom("Futura-Bold", size: 20.0))
                        
                        Button(action: {
                            // Action to perform when the button is tapped. send link to webview or safari
                            print("Button tapped!")
                        }) {
                            Text(recipe.source_url)
                                .font(.custom("Futura-Medium", size: 16.0)).foregroundColor(Color(.black))
                                .underline()
                                .multilineTextAlignment(.leading)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Video")
                            .font(.custom("Futura-Bold", size: 20.0))
                        
                        Button(action: {
                            // Action to perform when the button is tapped. send link to webview or safari
                            print("Button tapped!")
                        }) {
                            Text(recipe.youtube_url)
                                .font(.custom("Futura-Medium", size: 16.0)).foregroundColor(Color(.black))
                                .underline()
                                .multilineTextAlignment(.leading)
                        }
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
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }
        }
        .onAppear {
            self.loadImage(for: recipe.photo_url_large)
        }
    }
    
    func loadImage(for urlString: String) {
        guard let url = URL(string: urlString) else { return }
        loadedImage = nil
        if let cachedImage = ImageCacheManager.shared.loadImageFromCache(for: url) {
            loadedImage = cachedImage
        } else {
            ImageCacheManager.shared.downloadImage(from: url) { image in
                if let image = image {
                    DispatchQueue.main.async {
                        loadedImage = Image(uiImage: image)
                    }
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
