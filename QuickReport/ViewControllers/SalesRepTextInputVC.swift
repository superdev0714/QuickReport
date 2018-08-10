//
//  SalesRepTextInputVC.swift
//  QuickReport
//
//  Created by Atikur Rahman on 10/8/18.
//  Copyright © 2018 Atikur Rahman. All rights reserved.
//

import UIKit

class SalesRepTextInputVC: UIViewController {
    
    var typesOfLearning = [String]()
    
    @IBOutlet weak var typeOfLearningPicker: UIPickerView!
    @IBOutlet weak var learningTextView: UITextView!
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "SalesRepNext", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typesOfLearning = [
            "Products",
            "Competitors",
            "Industry",
            "Substrates",
            "Customers/Applicators",
            "Safety",
            "Other"
        ]
        
        typeOfLearningPicker.delegate = self
        typeOfLearningPicker.dataSource = self
        
        typeOfLearningPicker.setValue(UIColor.black, forKey: "textColor")
        typeOfLearningPicker.backgroundColor = .white
    }
}

extension SalesRepTextInputVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typesOfLearning.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typesOfLearning[row]
    }
}
