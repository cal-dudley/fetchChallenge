//
//  ViewController.swift
//  fetchChallenge
//
//  Created by Cal Dudley on 2/21/23.
//

import UIKit
import SDWebImage

class ViewController: UIViewController, RecipeManagerDelegate, RecipeDescriptionManagerDelegate{
    
    //Models that will allow us to store our dessert info
    var recipies : [RecipeModel]?
    var recipiesDescription : RecipeDescriptionModel?

    //Create a Recipe Manager object to network with
    var recipeManager = RecipeManager()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 150.00
        tableView.dataSource = self
        tableView.delegate = self
        
        //Delegates to help us interact with networking calls
        recipeManager.delegate = self
        recipeManager.delegateDescriptions = self
        
        //Fetches our dessert image, name, and ID
        recipeManager.fetchDesserts()
        
    }
    //Function that populates our model with the dessert image, ID, and title and reloads data once networking for all the meals is performed
    func didGetRecipes(recipes: [RecipeModel]) {
        recipies = recipes
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //Prepares to segue by sending over the recipe instructions, ingredients, measurements, and name
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DescriptionViewController
        destinationVC.recipiesDescription = recipiesDescription
    }
    
    //Function that populates our model with the recipe instructions, ingredients, measurements, and name and then segues, once the networking for an individual meal is performed
    
    func didGetRecipeDescriptions(recipes: RecipeDescriptionModel) {
        recipiesDescription = recipes
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "goToDescription", sender: self)
        }

    }
}

//DataSource and Delegate methods

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return recipies?.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        //Remove past views from cell
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        //Creating a content view
        let view = UIView()
        
        //Creating an image view to display jpg image
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        
        //Gets the jpg image using the SDWebImage framework
        
        var urlString = recipies?[indexPath.section].strMealThumb
        urlString = urlString?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        imageView.sd_setImage(with: URL(string: urlString!), placeholderImage: UIImage(named: "placeholder.png"))
        view.addSubview(imageView)
        
        //Adds the text view with the meal name to the content view
        let textView = UITextView(frame: CGRect(x: 160, y: 5, width: Int(UIScreen.main.bounds.size.width-200), height: 140))
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 20)
        textView.text = recipies?[indexPath.section].strMeal
        textView.centerVertically()
        view.addSubview(textView)
        
        
        
        cell.contentView.addSubview(view)

        cell.backgroundColor = .white
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Make sure the dessert name from our model is accessible before networking for that specific dessert
        
        guard let recipeID = recipies?[indexPath.section].idMeal else {
            print("Recipe doesn't exist")
            return
        }
        
        //Triggers recipeManager to retrieve individual meal instructions, ingredients and measurements
        recipeManager.fetchRecipe(with: recipeID)
    }
    
}

//Extension used to center UITextView vertically
extension UITextView {
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
}
