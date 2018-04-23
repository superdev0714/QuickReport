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
    
    @IBOutlet weak var projectNameTextView: UITextView!
    @IBOutlet weak var builderTextView: UITextView!
    @IBOutlet weak var applicatorTextView: UITextView!
    @IBOutlet weak var painterTextView: UITextView!
    @IBOutlet weak var substrateTextView: UITextView!
    @IBOutlet weak var systemTextView: UITextView!
    @IBOutlet weak var jobSizeTextView: UITextView!
    @IBOutlet weak var extraInfoTextView: UITextView!
    
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
        
        projectNameTextView.delegate = self
        builderTextView.delegate = self
        applicatorTextView.delegate = self
        painterTextView.delegate = self
        substrateTextView.delegate = self
        systemTextView.delegate = self
        jobSizeTextView.delegate = self
        extraInfoTextView.delegate = self
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
            let destinationVC = segue.destination as! ImageAttachVC
            destinationVC.projectName = projectNameTextView.text
            destinationVC.builder = builderTextView.text
            destinationVC.applicator = applicatorTextView.text
            destinationVC.painter = painterTextView.text
            destinationVC.substrate = substrateTextView.text
            destinationVC.system = systemTextView.text
            destinationVC.jobSize = jobSizeTextView.text
            destinationVC.extraInfo = extraInfoTextView.text
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
        
        // don't move the view for first four textViews
        if projectNameTextView.isFirstResponder ||
            builderTextView.isFirstResponder ||
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

extension TextInputVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

