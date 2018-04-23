//
//  SecondTextInputVC.swift
//  QuickReport
//
//  Created by Atikur Rahman on 23/4/18.
//  Copyright © 2018 Atikur Rahman. All rights reserved.
//

import UIKit

class SecondTextInputVC: UIViewController {
    
    @IBOutlet weak var builderTextView: UITextView!
    @IBOutlet weak var applicatorTextView: UITextView!
    @IBOutlet weak var painterTextView: UITextView!
    @IBOutlet weak var substrateTextView: UITextView!
    @IBOutlet weak var systemTextView: UITextView!
    @IBOutlet weak var jobSizeTextView: UITextView!
    @IBOutlet weak var extraInfoTextView: UITextView!
    
    var projectName: String?
    var projectAddr: String?
    var projectBg: String?
    var customerName: String?
    var customerPhone: String?
    var customerEmail: String?
    var projectCompletionDate: String?
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "ImageUploadScreen", sender: nil)
    }
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        builderTextView.delegate = self
        applicatorTextView.delegate = self
        painterTextView.delegate = self
        substrateTextView.delegate = self
        systemTextView.delegate = self
        jobSizeTextView.delegate = self
        extraInfoTextView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ImageUploadScreen" {
            let destinationVC = segue.destination as! ImageAttachVC
            
            destinationVC.projectName = projectName
            destinationVC.projectAddr = projectAddr
            destinationVC.projectBg = projectBg
            destinationVC.customerName = customerName
            destinationVC.customerPhone = customerPhone
            destinationVC.customerEmail = customerEmail
            destinationVC.projectCompletionDate = projectCompletionDate
            
            destinationVC.builder = builderTextView.text
            destinationVC.applicator = applicatorTextView.text
            destinationVC.painter = painterTextView.text
            destinationVC.substrate = substrateTextView.text
            destinationVC.system = systemTextView.text
            destinationVC.jobSize = jobSizeTextView.text
            destinationVC.extraInfo = extraInfoTextView.text
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
        // don't move the view for first three textViews
        if builderTextView.isFirstResponder ||
            applicatorTextView.isFirstResponder ||
            painterTextView.isFirstResponder {
                return
        }
        
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

extension SecondTextInputVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
