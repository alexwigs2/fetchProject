//
//  RecipesViewModel.swift
//  fetchProject
//
//  Created by Alex Wigsmoen on 4/5/25.
//

import Foundation

class RecipesViewModel: ObservableObject {
    @Published private(set) var recipes = [Recipe]()
    @Published var doneLoading = false
    
    func getData(completion: @escaping(_ recipeArray: [[String: Any]]) -> Void) {
        let urlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!)
        DispatchQueue.global(qos: .background).async {
            let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler:
                                                    { (data: Data?, response: URLResponse?, errorActual: Error?) in
                var returnJSON:[String:Any]?
                var errorMessage = ""
                
                if errorActual == nil {
                    let response = response as? HTTPURLResponse
                    if let data = data, response?.statusCode == 200 {
                        returnJSON = try! JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                    } else {
                        let codeIs = String(describing: response?.statusCode)
                        errorMessage = "data error, \(codeIs)"
                        DispatchQueue.main.async {
                            self.doneLoading = true
                        }
                        completion([])
                    }
                } else {
                    errorMessage = (errorActual?.localizedDescription)!
                    DispatchQueue.main.async {
                        self.doneLoading = true
                    }
                    completion([])
                }
                
                if errorMessage != "" {
                    print("error \(errorMessage)")
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
            })
            task.resume()
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
