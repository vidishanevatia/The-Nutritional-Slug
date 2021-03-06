//
//  customViewController.swift
//  SlugNutrition
//
//  Created by Roberto on 7/5/20.
//  Copyright © 2020 Roberto Oregon. All rights reserved.
//

import UIKit

var breakfastList: [MealProducts] = []
var lunchList: [MealProducts] = []
var dinnerList: [MealProducts] = []

var CalorieAlert:Bool = false
var FatAlert:Bool = false
var CarbAlert:Bool = false
var ProtienAlert:Bool = false

class customViewController: UIViewController {

    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet weak var CarbsDailyProgress: UIProgressView!
    @IBOutlet weak var FatsDailyProgress: UIProgressView!
    @IBOutlet weak var ProteinDailyProgress: UIProgressView!
    @IBOutlet weak var CaloriesDailyProgress: UIProgressView!
    
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var fatsLabel: UILabel!
    @IBOutlet weak var carbsLabel: UILabel!

    var proteinProgress:Float = 0.0
    var carbsProgress:Float = 0.0
    var fatsProgress:Float = 0.0
    var calProgress:Float = 0.0
    
    var defaultName:String = ""
    var defaultGenderIndex:Int = 0
    var defaultAge: Int = 0
    var defaultWeight: Double = 0.0
    var defaultHeight: Double = 0.0
    var defaultGoalRow:Int = 0
    var defaultActivityRow: Int = 0
    var defaultDate: Date?  //default date to be used between progress and daily
    var dateRating: Int = 0
    var selected: String = ""
    var cals:Double = 0.0
    var carbs:Double = 0.0
    var fat:Double = 0.0
    var pros:Double = 0.0
    
    @IBOutlet weak var breakfastProducts: UILabel!
    @IBOutlet weak var lunchProducts: UILabel!
    @IBOutlet weak var dinnerProducts: UILabel!
    
    var product1: MealProducts = MealProducts(item_name: "generic", brand_name: "meh", nf_calories: 100.0, nf_total_fat: 100.0, nf_total_carbohydrate: 100.0, nf_protein: 100.0)
    var breakfastResult = " "
    var lunchResult = " "
    var dinnerResult = " "
    
    let controller:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as UIViewController
        
        
    func calculateCalories(sex: Int, weight: Double, height: Double, age: Int, goal: Int, userActivity: Double ) -> Double {
        let x = 10 * (weight / 2.2046)
        let y = 6.25 * (height * 2.54)
        let z = (5 * age)
        if sex == 0 {
            return ((x + y - Double(z) + 5) * userActivity - 200) + Double(goal)
        }
        else {
            return ((x + y - Double(z) - 161) * userActivity - 200) + Double(goal)
        }
    }

    func calculateProteins(weight: Double ) -> Double {
        //let f = floor(w)
        let x = weight * 0.9
        return x
    }

    func calculateFats(calorieGoal: Double ) -> Double {
        //let f = floor(w)
        let x = 0.25 * calorieGoal / 9
        return x
    }

    func calculateCarbs(calorieGoal: Double, fatsGoal: Double, proteinGoal: Double) -> Double{
        let x = (calorieGoal - 9 * fatsGoal - 4 * proteinGoal) / 4
        return x
    }
    
    func incrementProgress(pros: Double){
        for products in breakfastList {
            proteinProgress = proteinProgress + Float(products.nf_protein)
            carbsProgress = carbsProgress + Float(products.nf_total_carbohydrate)
            fatsProgress = fatsProgress + Float(products.nf_total_fat)
            calProgress = calProgress + Float(products.nf_calories)
        }
        for products in lunchList {
            proteinProgress = proteinProgress + Float(products.nf_protein)
            carbsProgress = carbsProgress + Float(products.nf_total_carbohydrate)
            fatsProgress = fatsProgress + Float(products.nf_total_fat)
            calProgress = calProgress + Float(products.nf_calories)
        }
        for products in dinnerList {
            proteinProgress = proteinProgress + Float(products.nf_protein)
            carbsProgress = carbsProgress + Float(products.nf_total_carbohydrate)
            fatsProgress = fatsProgress + Float(products.nf_total_fat)
            calProgress = calProgress + Float(products.nf_calories)
        }
        
        proteinProgress = proteinProgress / Float(pros)
        carbsProgress = carbsProgress / Float(carbs)
        fatsProgress = fatsProgress / Float(fat)
        calProgress = calProgress / Float(cals)
        
        ProteinDailyProgress.progress = proteinProgress
        CarbsDailyProgress.progress = carbsProgress
        FatsDailyProgress.progress = fatsProgress
        CaloriesDailyProgress.progress = calProgress
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = getUserDefaults()
        defaultName = defaults.string(forKey:"defaultName") ?? ""
        defaultGenderIndex = defaults.integer(forKey: "defaultGender")
        defaultAge = defaults.integer(forKey:"defaultAge")
        defaultWeight = defaults.double(forKey:"defaultWeight")
        defaultHeight = defaults.double(forKey: "defaultHeight")
        defaultGoalRow = defaults.integer(forKey: "defaultGoal")
        defaultActivityRow = defaults.integer(forKey: "defaultActivity")
        defaultDate = defaults.object(forKey:"defaultDate") as? Date
        dateRating = defaults.integer(forKey:"dateRating")
        
        //user's first time loading, set the date
        if defaultDate == nil{
            defaultDate = Date()
            UserDefaults.standard.set(defaultDate, forKey: "defaultDate")
            UserDefaults.standard.synchronize()
        }

    }

    override func viewWillAppear(_ animated: Bool) {
    
        navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
        if (defaultName == "")
        {
            self.present(controller, animated: true, completion: nil)
        }
        else
        {
            userNameLabel.text = defaultName.uppercased() + "'S TODAY"
        }
        
        //if the date has changed since last access date, rate the last day and reset daily progress
        if (dateChanged(lastDate: defaultDate!)){
            
            dateRating = rateDay()
            UserDefaults.standard.set(dateRating, forKey:"dateRating")
            UserDefaults.standard.synchronize()
            
            //reset everything
            proteinProgress = 0.0
            carbsProgress = 0.0
            fatsProgress = 0.0
            calProgress = 0.0
            
            ProteinDailyProgress.progress = proteinProgress
            CarbsDailyProgress.progress = carbsProgress
            FatsDailyProgress.progress = fatsProgress
            CaloriesDailyProgress.progress = calProgress
            
            caloriesLabelFunction()
            proteinLabelFunction()
            fatsLabelFunction()
            carbsLabelFunction()
            
            breakfastProducts.text = ""
            lunchProducts.text = ""
            dinnerProducts.text = ""
            
        }else{
            
            macrosCalculated()
            incrementProgress(pros: pros)
            
            caloriesLabelFunction()
            proteinLabelFunction()
            fatsLabelFunction()
            carbsLabelFunction()
            for products in breakfastList {
                breakfastResult += " " + products.item_name
            }
            for products in lunchList {
                lunchResult += " " + products.item_name
            }
            for products in dinnerList {
                dinnerResult += " " + products.item_name
            }
                   
            breakfastProducts.text = String(breakfastResult.prefix(18))
            lunchProducts.text = String(lunchResult.prefix(18))
            dinnerProducts.text = String(dinnerResult.prefix(18))
            
        }
    }   //end of viewWillAppear()

    func getGoal() -> Int{
        var goal:Int
        switch defaultGoalRow
        {
            case 0 : goal = 0
            case 1 : goal = 300
            case 2 :  goal = -300
            default : goal = 0
        }
        return goal
    }
        
    func getActivity() -> Double{
        var activity:Double
        switch defaultActivityRow
        {
            case 0 : activity = 1.2
            case 1 :  activity = 1.375
            case 2 :  activity = 1.55
            case 3 :  activity = 1.725
            case 4 :  activity = 1.9
            default : activity = 0
        }
        return activity
    }
    
    func convertStringValToInt(name: String) -> Int {
        let value = "\(name)"
        var to_numeric = ""
        for letter in value.unicodeScalars{
            if 48...57 ~= letter.value{
                to_numeric.append(String(letter))
            }
        }
        let temp = Int(to_numeric) ?? 0
        return temp
    }

    //global boolean arrays, only once will it switch
    func DailyMaxValAlert(macro: String){
        let message = UIAlertController(title: "Put down that Pizza!", message: "You have reached your " + macro + " limit for today", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in print("Ok button tapped") })

        message.addAction(dismiss)
        self.present(message, animated: true, completion: nil)
    }
        
    func macrosCalculated() {
        pros = calculateProteins(weight: defaultWeight)
        cals = calculateCalories(sex: defaultGenderIndex,weight: defaultWeight,height: defaultHeight,age: defaultAge,goal: getGoal(), userActivity: getActivity())
        carbs = calculateCarbs(calorieGoal: cals,fatsGoal: fat, proteinGoal: pros)
        fat = calculateFats(calorieGoal: cals)
    }
    
    func caloriesLabelFunction() {
        self.caloriesLabel.text = String(format: "%.0f", CaloriesDailyProgress.progress * Float(cals)) + "/" + String(Int(cals))
        if CaloriesDailyProgress.progress >= 1 {
                 if !(CalorieAlert) {DailyMaxValAlert(macro: "Calorie")}

                 caloriesLabel.textColor = UIColor.systemRed
                 CalorieAlert = true
             }
    }
        
    func proteinLabelFunction() {
        self.proteinLabel.text = String(format: "%.0f", ProteinDailyProgress.progress * Float(pros)) + "/" + String(Int(pros))
        if ProteinDailyProgress.progress >= 1{
                  if !(ProtienAlert) {DailyMaxValAlert(macro: "Protien")}

                  proteinLabel.textColor = UIColor.systemRed
                  ProtienAlert = true
              }
        
    }
        
    func fatsLabelFunction() {
        self.fatsLabel.text = String(format: "%.0f", FatsDailyProgress.progress * Float(fat)) + "/" + String(Int(fat))
        print(FatsDailyProgress.progress)
               if FatsDailyProgress.progress >= 1 {
                   if !(FatAlert){ DailyMaxValAlert(macro: "Fat") }

                   fatsLabel.textColor = UIColor.systemRed
                   FatAlert = true

               }
    }
        
    func carbsLabelFunction() {
        self.carbsLabel.text = String(format: "%.0f", CarbsDailyProgress.progress * Float(carbs) ) + "/" + String(Int(carbs))
        if (CarbsDailyProgress.progress >= 1) && !(CarbAlert){
                   if !(CarbAlert) { DailyMaxValAlert(macro: "Carbohydrate")}

                   carbsLabel.textColor = UIColor.systemRed
                   CarbAlert = true
               }
    }
    
    //function compares last access date to current date to see if the day has changed
    //Input: last access date
    //Output: boolean value (true if dateChanged, false if not)
    func dateChanged(lastDate: Date) -> Bool{
        let now = Date()
        var result: Bool = false
        
        let lastDateDay = Calendar.current.dateComponents([.day], from: lastDate)
        let nowDay = Calendar.current.dateComponents([.day], from: now)
        
        //if lastDate is today, date hasn't changed so return false
        if (lastDateDay == nowDay){
            return result
        } else {
            result = true
            return result
        }
    }
    
    //function rates the progress made within a day
    //Input: no input, uses global vars
    //Output: Integer value [1 - Good, 2 - Okay, 3 - Bad]
    func rateDay() -> Int{
        var rating: Int = 0  //return value for rating of the day [1-good, 2-okay, 3-bad]

        let proRating: Int  = progressWithIn(goal:pros, progress:proteinProgress)
        let carbRating: Int  = progressWithIn(goal:carbs, progress:carbsProgress)
        let fatRating: Int  = progressWithIn(goal:fat, progress:fatsProgress)
        let calRating: Int  = progressWithIn(goal:cals, progress:calProgress)
        
        let totalRating = proRating + carbRating + fatRating + calRating
        
        //if rating = 40, it was a Good day
        // (4/4 goals +/- 10, 3/4 goals +/- 5)
        // [4*10 or 3*5+25]
        if (totalRating == 40){
            rating = 1
        }
        //if rating is somewhere between 40 and 100, it was an Okay day
        // (4/4 goals +/- 25, 3/4 goals +/- 15, 2/4 goals +/- 5)
        else if (totalRating <= 100){
            rating = 2
        }
        //if rating is greater than 100, the day was Bad
        else {
            rating = 3
        }
        
        return rating
    }
    
    //function calculates how close the user's progress is to their goal for a specified macro
    //Input: MacroGoal, MacroProgress
    //Output: The range of +/- the MacroGoal which the MacroProgress is within
    func progressWithIn(goal: Double, progress: Float) -> Int{
        
        var withIn: Int = 100
        
        if (((goal - 25)...(goal + 25)).contains(Double(progress))){
            if (((goal - 15)...(goal + 15)).contains(Double(progress))){
                if (((goal - 10)...(goal + 10)).contains(Double(progress))){
                    if (((goal - 5)...(goal + 5)).contains(Double(progress))){
                        withIn = 5
                    }
                    withIn = 10
                }
                withIn = 15
            }
            withIn = 25
        }
        
        //progress is withIn [return value] of the goal
        return withIn
    }
    
    func getUserDefaults() -> UserDefaults {
        let defaults = UserDefaults.standard
        if (defaults.object(forKey: "defaultName") == nil) {
        // set initial defaults
        defaults.set(defaultGenderIndex, forKey: "defaultGender")
        defaults.set(defaultAge,forKey: "defaultAge")
        defaults.set(defaultWeight, forKey: "defaultWeight")
        defaults.set(defaultHeight, forKey: "defaultHeight")
        defaults.set(defaultGoalRow,forKey: "defaultGoal")
        defaults.set(defaultActivityRow,forKey: "defaultActivity")
        defaults.set(defaultDate, forKey: "defaultDate")
        defaults.set(dateRating, forKey: "dateRating")
        defaults.synchronize()
        }
        return defaults
    }
    
}
