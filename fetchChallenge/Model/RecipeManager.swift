//
//  RecipeManager.swift
//  fetchChallenge
//
//  Created by Cal Dudley on 2/21/23.
//

import Foundation

protocol RecipeManagerDelegate {
    func didGetRecipes(recipes: [RecipeModel])
}
protocol RecipeDescriptionManagerDelegate {
    func didGetRecipeDescriptions(recipes: RecipeDescriptionModel)
}

struct RecipeManager {
    
    let desertURL = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
    
    
    //Creating delegates to retireve networking info
    
    var delegate: RecipeManagerDelegate?
    var delegateDescriptions: RecipeDescriptionManagerDelegate?
    
    //Code for when the app first opens that retrieves all the Deserts
    
    func fetchDesserts() {
        networkingRequest(url: desertURL)
    }
    
    func networkingRequest(url: String) {
        
        //Creating URL
        
        if let url = URL(string: url) {
            
            //Creating URL Session
            
            let session = URLSession(configuration: .default)
            
            //Creating task
            
            let task = session.dataTask(with: url) { data, response, error in
                    if error != nil {
                        print(error!)
                        return
                    }
                
                    if let safeData = data {
                        
                        //Calling function to parse json, and if successful, uses delegate to call didGetRecipes() which displays desserts in the VC
                        
                        if let recipes = self.parseJSON(desertData: safeData) {
                            self.delegate?.didGetRecipes(recipes: recipes)
                        }
                    }
            }
            task.resume()
        }
        
    }
    //Parsing JSON
    
    func parseJSON(desertData: Data) -> [RecipeModel]? {
        let decoder = JSONDecoder()
        do {
            
            //Decoding Desserts and loading them into our model
            
            var recipeArr = [RecipeModel]()
            let decodedData = try decoder.decode(RecipeData.self, from: desertData)
            for i in decodedData.meals {
                let recipe = RecipeModel(strMealThumb: i.strMealThumb, idMeal: i.idMeal, strMeal: i.strMeal)
                recipeArr.append(recipe)
            }
            return recipeArr
        }
        catch {
            print("Decoding error: \(error)")
            return nil
        }
    }
    
    
    
    
    
    //Code when the user selects a Desert in order to retreive that's desert instructions, ingredients, and measurements
    
    func fetchRecipe(with: String) {
        
        //Creating URL
        
        if let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(with)") {
            
            //Creating URLSession
            
            let session = URLSession(configuration: .default)
            
            //Creating task
            
            let task = session.dataTask(with: url) { data, response, error in
                    if error != nil {
                        print(error!)
                        return
                    }
                    if let safeData = data {
                        
                        //Calling function to parse json, and if successful, uses delegate to call didGetRecipeDescriptions() which displays dessert instructions, ingredients, and measurements in a new VC
                        
                        if let recipes = self.parseJSONRecipe(desertData: safeData) {
                            self.delegateDescriptions?.didGetRecipeDescriptions(recipes: recipes)
                        }
                    }
            }
            task.resume()
        }
        
    }
    //Parsing JSON
    func parseJSONRecipe(desertData: Data) -> RecipeDescriptionModel? {
        let decoder = JSONDecoder()
        do {
            
            //Decoded an individual dessert's instructions, ingredients, and measurements and loads them into our model
            
            let decodedData = try decoder.decode(RecipeDescriptionData.self, from: desertData)
            let recipe = RecipeDescriptionModel(strMeal: decodedData.meals[0].strMeal, strInstructions: decodedData.meals[0].strInstructions, strIngredients: [String(decodedData.meals[0].strIngredient1 ?? ""), String(decodedData.meals[0].strIngredient2 ?? ""), String(decodedData.meals[0].strIngredient3 ?? ""), String(decodedData.meals[0].strIngredient4 ?? ""), String(decodedData.meals[0].strIngredient5 ?? ""), String(decodedData.meals[0].strIngredient6 ?? ""), String(decodedData.meals[0].strIngredient7 ?? ""), String(decodedData.meals[0].strIngredient8 ?? ""), String(decodedData.meals[0].strIngredient9 ?? ""), String(decodedData.meals[0].strIngredient10 ?? ""),String(decodedData.meals[0].strIngredient11 ?? ""), String(decodedData.meals[0].strIngredient12 ?? ""), String(decodedData.meals[0].strIngredient13 ?? ""), String(decodedData.meals[0].strIngredient14 ?? ""), String(decodedData.meals[0].strIngredient15 ?? ""),String(decodedData.meals[0].strIngredient16 ?? ""), String(decodedData.meals[0].strIngredient17 ?? ""), String(decodedData.meals[0].strIngredient18 ?? ""), String(decodedData.meals[0].strIngredient19 ?? ""), String(decodedData.meals[0].strIngredient20 ?? "")], strMeasures: [String(decodedData.meals[0].strMeasure1 ?? ""), String(decodedData.meals[0].strMeasure2 ?? ""), String(decodedData.meals[0].strMeasure3 ?? ""), String(decodedData.meals[0].strMeasure4 ?? ""), String(decodedData.meals[0].strMeasure5 ?? ""), String(decodedData.meals[0].strMeasure6 ?? ""), String(decodedData.meals[0].strMeasure7 ?? ""), String(decodedData.meals[0].strMeasure8 ?? ""), String(decodedData.meals[0].strMeasure9 ?? ""), String(decodedData.meals[0].strMeasure10 ?? ""),String(decodedData.meals[0].strMeasure11 ?? ""), String(decodedData.meals[0].strMeasure12 ?? ""), String(decodedData.meals[0].strMeasure13 ?? ""), String(decodedData.meals[0].strMeasure14 ?? ""), String(decodedData.meals[0].strMeasure15 ?? ""),String(decodedData.meals[0].strMeasure16 ?? ""), String(decodedData.meals[0].strMeasure17 ?? ""), String(decodedData.meals[0].strMeasure18 ?? ""), String(decodedData.meals[0].strMeasure19 ?? ""), String(decodedData.meals[0].strMeasure20 ?? "")])
            return recipe
        }
        catch {
            print("Decoding error: \(error)")
            return nil
        }
    }
    
    
}
