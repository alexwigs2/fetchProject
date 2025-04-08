//
//  ImageCacheManager.swift
//  fetchProject
//
//  Created by Alex Wigsmoen on 4/7/25.
//

import SwiftUI

class ImageCacheManager {
    static let shared = ImageCacheManager()
    
    private init() {}
    
    func loadImageFromCache(for url: URL) -> Image? {
        let fileManager = FileManager.default
        if let cachedFileURL = cachedImageURL(for: url), fileManager.fileExists(atPath: cachedFileURL.path) {
            if let imageData = try? Data(contentsOf: cachedFileURL), let uiImage = UIImage(data: imageData) {
                return Image(uiImage: uiImage)
            }
        }
        return nil
    }
    
    func saveImageToCache(image: UIImage, for url: URL) {
        guard let imageData = image.pngData() else { return }
        do {
            if let cachedFileURL = cachedImageURL(for: url) {
                try imageData.write(to: cachedFileURL)
            }
        } catch {
            print("Error saving image to cache: \(error)")
        }
    }
    
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil, let uiImage = UIImage(data: data) else {
                completion(nil)
                return
            }
            self.saveImageToCache(image: uiImage, for: url)
            completion(uiImage)
        }.resume()
    }
    
    func cachedImageURL(for url: URL) -> URL? {
        let fileManager = FileManager.default
        guard let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        let fileName = url.absoluteString
        return cachesDirectory.appendingPathComponent(fileName)
    }
}
