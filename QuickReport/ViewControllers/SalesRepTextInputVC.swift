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
        
        learningTextView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SalesRepNext" {
            let destinationVC = segue.destination as! SalesRepImageAttachVC
            destinationVC.typeOfLearning = typesOfLearning[typeOfLearningPicker.selectedRow(inComponent: 0)]
            destinationVC.learning = learningTextView.text
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeKeyboardNotifications()
    }
    
    // MARK: - Subscribe/unsubscribe keyboard notifications
    
    private func subscribeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: .UIKeyboardWillHide, object: nil)
    }
    
    private func unsubscribeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self,
                                                  name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: .UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - Handle keyboard notifications
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
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

extension SalesRepTextInputVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
