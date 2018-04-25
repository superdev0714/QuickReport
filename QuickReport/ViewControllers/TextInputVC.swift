//
//  TextInputVC.swift
//  QuickReport
//
//  Created by Atikur Rahman on 18/4/18.
//  Copyright © 2018 Atikur Rahman. All rights reserved.
//

import UIKit

class TextInputVC: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var projectCompletionDatePicker: UIDatePicker!
    //    @IBOutlet weak var projectNameTextView: UITextView!
//    @IBOutlet weak var projectAddrTextView: UITextView!
//    @IBOutlet weak var projectBgTextView: UITextView!
//    @IBOutlet weak var customerNameTextView: UITextView!
//    @IBOutlet weak var customerPhoneTextView: UITextView!
//    @IBOutlet weak var customerEmailTextView: UITextView!
//    @IBOutlet weak var projectCompletionDateTextView: UITextView!
    @IBOutlet weak var nextButton: UIButton!
    
    let keyName = "uname"
    let defaults = UserDefaults.standard
    var isUserEnteredName = false

    // MARK: - Actions
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "NextScreen", sender: nil)
    }
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.imageView?.contentMode = .scaleAspectFit
        
        projectCompletionDatePicker.setValue(UIColor.white, forKey: "textColor")
        
//        projectNameTextView.delegate = self
//        projectAddrTextView.delegate = self
//        projectBgTextView.delegate = self
//        customerNameTextView.delegate = self
//        customerPhoneTextView.delegate = self
//        customerEmailTextView.delegate = self
//        projectCompletionDateTextView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let uname = defaults.string(forKey: keyName) {
            print("hello \(uname)")
            isUserEnteredName = true
        } else {
            print("show alert to set user name.")
            getUserNameAlert()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NextScreen" {
//            let destinationVC = segue.destination as! SecondTextInputVC
//            destinationVC.projectName = projectNameTextView.text
//            destinationVC.projectAddr = projectAddrTextView.text
//            destinationVC.projectBg = projectBgTextView.text
//            destinationVC.customerName = customerNameTextView.text
//            destinationVC.customerPhone = customerPhoneTextView.text
//            destinationVC.customerEmail = customerEmailTextView.text
//            destinationVC.projectCompletionDate = projectCompletionDateTextView.text
        }
    }
    
    // MARK: - Username input
    
    private func getUserNameAlert() {
        let alert = UIAlertController(title: "Enter your name", message: nil, preferredStyle: .alert)
        alert.addTextField {
            textField in
            textField.placeholder = "Your Name"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {[weak alert] (_)in
            guard let textField = alert?.textFields?.first else {
                return
            }
            
            guard let name = textField.text, !name.isEmpty else {
                // keep showing alert until username is provided
                self.getUserNameAlert()
                return
            }
            
            self.defaults.set(name, forKey: self.keyName)
            self.isUserEnteredName = true
        }))
        
        present(alert, animated: true)
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
        // don't move the view before username is provided
        if !isUserEnteredName {
            return
        }
        
//        // don't move the view for first three textViews
//        if projectNameTextView.isFirstResponder ||
//            projectAddrTextView.isFirstResponder ||
//            projectBgTextView.isFirstResponder {
//                return
//        }
        
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

extension TextInputVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

