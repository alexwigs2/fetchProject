//
//  RecipeCard.swift
//  fetchProject
//
//  Created by Alex Wigsmoen on 4/5/25.
//

import SwiftUI

struct RecipeCard: View {
    var recipe: Recipe
    @State private var loadedImage: Image? = nil
    @State private var isLoading = true
    
    var body: some View {
        VStack {
            if self.isLoading {
                ZStack {
                    Rectangle()
                        .foregroundColor(Color.gray.opacity(0.3))
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40, alignment: .center)
                        .foregroundColor(.white.opacity(0.7))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            } else {
                ZStack {
                    if let image = loadedImage {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 300)
                    } else {
                        ZStack {
                            Rectangle()
                                .foregroundColor(Color.gray.opacity(0.3))
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40, alignment: .center)
                                .foregroundColor(.white.opacity(0.7))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    Text(recipe.name)
                        .font(.custom("Futura-Bold", size: 17.0))
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 3, x: 0, y: 0)
                        .padding()
                        .frame(maxWidth: 136)
                        .lineLimit(nil)
                }
            }
        }
        .frame(width: 160, height: 217, alignment: .top)
        .background(LinearGradient(gradient: Gradient(colors: [Color(.gray).opacity(0.3), Color(.gray)]), startPoint: .top, endPoint: .bottom))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.black.opacity(0.2), radius: 15, x: 0, y: 10)
        .onAppear {
            loadImage(for: recipe.photo_url_small)
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
