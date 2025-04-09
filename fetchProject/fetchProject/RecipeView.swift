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
    @State private var isLoading = true
    
    var body: some View {
        ScrollView {
            if self.isLoading {
                ZStack {
                    Rectangle()
                        .foregroundColor(Color.gray.opacity(0.3))
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100, alignment: .center)
                        .foregroundColor(.white.opacity(0.7))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .frame(height: 300)
                }
            } else {
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
            }
            
            VStack(spacing: 30) {
                Text(recipe.name)
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.top, 45)
                
                VStack(alignment: .leading, spacing: 30) {
                    Text("Cuisine: \(recipe.cuisine)")
                        .font(.custom("Futura-Bold", size: 20.0))
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Website: ")
                            .font(.custom("Futura-Bold", size: 20.0))
                        if let url = URL(string: recipe.source_url) {
                            NavigationLink(destination: WebView(url: url)) {
                                Text(recipe.source_url)
                                    .font(.custom("Futura-Medium", size: 16.0))
                                    .foregroundColor(Color(.black))
                                    .underline()
                                    .multilineTextAlignment(.leading)
                            }
                        } else {
                            Text(recipe.source_url)
                                .font(.custom("Futura-Medium", size: 16.0)).foregroundColor(Color(.black))
                                .underline()
                                .multilineTextAlignment(.leading)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Video: ")
                            .font(.custom("Futura-Bold", size: 20.0))
      
                        if let url = URL(string: recipe.youtube_url) {
                            NavigationLink(destination: WebView(url: url)) {
                                Text(recipe.youtube_url)
                                    .font(.custom("Futura-Medium", size: 16.0))
                                    .foregroundColor(Color(.black))
                                    .underline()
                                    .multilineTextAlignment(.leading)
                            }
                        } else {
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
        self.isLoading = true
        if let cachedImage = ImageCacheManager.shared.loadImageFromCache(for: url) {
            DispatchQueue.main.async {
                self.loadedImage = cachedImage
                self.isLoading = false
            }
        } else {
            ImageCacheManager.shared.downloadImage(from: url) { image in
                if let image = image {
                    DispatchQueue.main.async {
                        self.loadedImage = Image(uiImage: image)
                        self.isLoading = false
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
