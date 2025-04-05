//
//  RecipeModel.swift
//  fetchProject
//
//  Created by Alex Wigsmoen on 4/5/25.
//

import Foundation

struct Recipe: Identifiable {
    let cuisine: String
    let name: String
    let photo_url_large: String
    let photo_url_small: String
    let id: String
    let source_url: String
    let youtube_url: String
}
