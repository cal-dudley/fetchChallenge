//
//  DescriptionViewController.swift
//  fetchChallenge
//
//  Created by Cal Dudley on 2/21/23.
//

import UIKit

class DescriptionViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textView2: UITextView!
    
    
    var recipiesDescription : RecipeDescriptionModel?
    
    override func viewDidLayoutSubviews() {
        DispatchQueue.main.async {
            
            //Setting the ScrollView height to match adapt to the amount of text
            
            self.scrollView.contentSize.height =
            self.textView.frame.height + self.textView2.frame.height + 100
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting the title and text views
        
        title = recipiesDescription?.strMeal
        
        textView.text = recipiesDescription!.strInstructions!
        
        var stringIngredientsMeasurements : String = ""
        
        //Quick loop to simply format the ingredients and measurements side by side
        for i in 0..<20 {
            if recipiesDescription!.strIngredients[i] != "" {
                stringIngredientsMeasurements += """
                \(recipiesDescription!.strIngredients[i])  -   \(recipiesDescription!.strMeasures[i])
                
                """
            }
        }
        textView2.text = stringIngredientsMeasurements
        
        //Resizing textView so they don't create empty white space
        textView.sizeToFit()
        textView2.sizeToFit()
        
    }

}
