//
//  CustomizedViewController.swift
//  SlugNutrition
//
//  Created by Vidisha Nevatia on 12/07/20.
//  Copyright © 2020 Roberto Oregon. All rights reserved.
//

import UIKit

class CustomizedViewController: UIViewController {
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var brandTextField: UITextField!
    @IBOutlet var mealSegmentedControl: UISegmentedControl!
    @IBOutlet var carbsTextField: UITextField!
    @IBOutlet var carbsSlider: UISlider!
    @IBOutlet var fatTextField: UITextField!
    @IBOutlet var fatSlider: UISlider!
    @IBOutlet var caloriesTextField: UITextField!
    @IBOutlet var caloriesSlider: UISlider!
    @IBOutlet var proteinTextField: UITextField!
    @IBOutlet var proteinSlider: UISlider!
    
    @IBOutlet var saveButton: UIButton!
    
    var defaultName = ""
    var defaultBrand = ""
    var defaultCarbs = 0.0
    var defaultFats = 0.0
    var defaultCals = 0.0
    var defaultPros = 0.0
    var defaultMeal = 1
    
//
//    var product: MealProducts = MealProducts(item_name: "generic", brand_name: "meh", nf_calories: 100.0, nf_total_fat: 100.0, nf_total_carbohydrate: 100.0, nf_protein: 100.0)
    
     override func viewDidLoad() {
         super.viewDidLoad()
        updateSaveButtonState()
     }
    
    
    
    @IBAction func defaultFoodNameChanged(_ sender: UITextField) {
        UserDefaults.standard.set(nameTextField.text, forKey: "defaultFoodName") // saves text field text
        UserDefaults.standard.synchronize()
    }
    
    
     @IBAction func defaultCarbsChanged(_ sender: UISlider) {
         updateCarbsValue()
     }
     @IBAction func defaultFatsChanged(_ sender: UISlider) {
             updateFatsValue()
         }
    @IBAction func defaultCalsChanged(_ sender: UISlider) {
            updateCalsValue()
        }
    @IBAction func defaultProsChanged(_ sender: UISlider) {
            updateProsValue()
        }
    
    @IBAction func mealSegmentedControl(_ sender: UISegmentedControl) {
        UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: "defaultMeal")
        UserDefaults.standard.synchronize()
    }
    
     
     func updateCarbsValue()
     {
          defaultCarbs = Double(carbsSlider.value)
        //product.nf_total_carbohydrate = Double(carbsSlider.value)
         carbsTextField.text = "\(defaultCarbs)"
         let defaults = UserDefaults.standard
         defaults.set(defaultCarbs, forKey: "defaultCarbs")
         defaults.synchronize()
        
     }
    @IBAction func CarbstextFieldDidChange(textField: UITextField) {
        if let stringValue = textField.text{
            if let intValue = Int(stringValue){
                carbsSlider.setValue(Float(intValue), animated: true)
            }
        }
            updateCarbsValue()
    }
     
     func updateFatsValue()
     {
         defaultFats = Double(fatSlider.value)
       // product.nf_total_fat = Double(fatSlider.value)
          fatTextField.text = "\(defaultFats)"
          let defaults = UserDefaults.standard
          defaults.set(defaultFats, forKey: "defaultFats")
          defaults.synchronize()
     }
    
    @IBAction func FatstextFieldDidChange(textField: UITextField) {
        if let stringValue = textField.text{
            if let intValue = Int(stringValue){
                fatSlider.setValue(Float(intValue), animated: true)
            }
        }
            updateFatsValue()
    }
     
     func updateCalsValue()
         {
             defaultCals = Double(caloriesSlider.value)
            //product.nf_calories = Double(caloriesSlider.value)
              caloriesTextField.text = "\(defaultCals)"
              let defaults = UserDefaults.standard
              defaults.set(defaultCals, forKey: "defaultCals")
              defaults.synchronize()
         }
    
   @IBAction func CalstextFieldDidChange(textField: UITextField) {
           if let stringValue = textField.text{
               if let intValue = Int(stringValue){
                   caloriesSlider.setValue(Float(intValue), animated: true)
               }
           }
               updateCalsValue()
       }

    func updateProsValue()
    {
        defaultPros = Double(proteinSlider.value)
        //product.nf_protein = Double(proteinSlider.value)
         proteinTextField.text = "\(defaultPros)"
         let defaults = UserDefaults.standard
         defaults.set(defaultPros, forKey: "defaultPros")
         defaults.synchronize()
    }
    
    @IBAction func ProstextFieldDidChange(textField: UITextField) {
           if let stringValue = textField.text{
               if let intValue = Int(stringValue){
                   proteinSlider.setValue(Float(intValue), animated: true)
               }
           }
               updateProsValue()
       }
    
    @IBAction func textEditingChanged(_sender: UITextField)
       {
           updateSaveButtonState()
            
       }
    
    func updateSaveButtonState() {
           let foodText = nameTextField.text ?? ""
           let brandText = brandTextField.text ?? ""
           saveButton.isEnabled = !foodText.isEmpty && !brandText.isEmpty
        
       }
    
    @IBAction func saveButton(_ sender: UIButton) {
//        product.item_name = nameTextField.text ?? ""
//        product.brand_name = brandTextField.text ?? ""
//        let defaults = UserDefaults.standard
//        defaults.set(defaultPros, forKey: "defaultMeal")
//        defaults.synchronize()
        
//        let mealSelected = UserDefaults.standard.integer(forKey: "defaultMeal")
        
//        if mealSelected == 1{
//            print("breakfast")
//            breakfastList.append(product)
//        }else if mealSelected == 2 {
//            print("lunch")
//            lunchList.append(product)
//        }else if mealSelected == 3 {
//            print("dinner")
//            dinnerList.append(product)
//        }
    }
    

    
}
