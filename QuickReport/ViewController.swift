//
//  ViewController.swift
//  QuickReport
//
//  Created by Atikur Rahman on 18/4/18.
//  Copyright © 2018 Atikur Rahman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var projectNameTextView: UITextView!
    @IBOutlet weak var builderTextView: UITextView!
    @IBOutlet weak var applicatorTextView: UITextView!
    @IBOutlet weak var painterTextView: UITextView!
    @IBOutlet weak var substrateTextView: UITextView!
    
    let keyName = "uname"
    let defaults = UserDefaults.standard
    var isUserEnteredName = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "NextScreen", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NextScreen" {
            let destinationVC = segue.destination as! ImageAttachVC
            destinationVC.projectName = projectNameTextView.text
            destinationVC.builder = builderTextView.text
            destinationVC.applicator = applicatorTextView.text
            destinationVC.painter = painterTextView.text
            destinationVC.substrate = substrateTextView.text
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if !isUserEnteredName {
            return
        }
        
        if projectNameTextView.isFirstResponder ||
            builderTextView.isFirstResponder {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
    
    func getUserNameAlert() {
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
                self.getUserNameAlert()
                return
            }
            
            self.defaults.set(name, forKey: self.keyName)
            self.isUserEnteredName = true
        }))
        
        present(alert, animated: true)
    }
}

