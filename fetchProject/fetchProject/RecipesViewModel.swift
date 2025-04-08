//
//  RecipesViewModel.swift
//  fetchProject
//
//  Created by Alex Wigsmoen on 4/5/25.
//

import Foundation

protocol NetworkService {
    func fetchData(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}

class URLSessionNetworkService: NetworkService {
    func fetchData(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}

class RecipesViewModel: ObservableObject {
    private let networkService: NetworkService
    @Published private(set) var recipes = [Recipe]()
    @Published var doneLoading = false
    
    init(networkService: NetworkService = URLSessionNetworkService()) {
        self.networkService = networkService
    }
    
    func getData(completion: @escaping(_ recipeArray: [[String: Any]]) -> Void) {
        let urlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
        guard let url = URL(string: urlString) else {
            completion([])
            return
        }
        
        networkService.fetchData(url: url) { data, response, error in
            var returnJSON: [String: Any]?
            var errorMessage = ""
            
            if error == nil {
                let response = response as? HTTPURLResponse
                if let data = data, response?.statusCode == 200 {
                    returnJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                } else {
                    errorMessage = "Data error, \(String(describing: response?.statusCode))"
                    DispatchQueue.main.async {
                        self.doneLoading = true
                    }
                    completion([])
                }
            } else {
                errorMessage = error?.localizedDescription ?? ""
                DispatchQueue.main.async {
                    self.doneLoading = true
                }
                completion([])
            }
            
            if !errorMessage.isEmpty {
                print("Error: \(errorMessage)")
                DispatchQueue.main.async {
                    self.doneLoading = true
                }
                completion([])
                return
            } else {
                let recipeArray = returnJSON?["recipes"] as? [[String: Any]] ?? []
                DispatchQueue.main.async {
                    self.doneLoading = true
                }
                completion(recipeArray)
            }
        }
    }
    
    func setData() {
        self.getData { recipeArray in
            if !recipeArray.isEmpty {
                DispatchQueue.main.async {
                    self.recipes.removeAll()
                    for dataActual in recipeArray {
                        if let cuisine = dataActual["cuisine"] as? String, cuisine != "",
                           let name = dataActual["name"] as? String, name != "",
                           let photo_url_large = dataActual["photo_url_large"] as? String, photo_url_large != "",
                           let photo_url_small = dataActual["photo_url_small"] as? String, photo_url_small != "",
                           let uuid = dataActual["uuid"] as? String, uuid != "",
                           let source_url = dataActual["source_url"] as? String, source_url != "",
                           let youtube_url = dataActual["youtube_url"] as? String, youtube_url != "" {
                            
                            let rec = Recipe(cuisine: cuisine, name: name, photo_url_large: photo_url_large, photo_url_small: photo_url_small, id: uuid, source_url: source_url, youtube_url: youtube_url)
                            
                            if !self.recipes.contains(where: { $0.id == uuid }) {
                                self.recipes.append(rec)
                            }
                        }
                    }
                }
            }
        }
    }
}
