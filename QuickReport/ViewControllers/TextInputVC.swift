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
    @IBOutlet weak var projectAddrTextView: UITextView!
    @IBOutlet weak var projectBgTextView: UITextView!
    @IBOutlet weak var customerNameTextView: UITextView!
    @IBOutlet weak var customerPhoneTextView: UITextView!
    @IBOutlet weak var customerEmailTextView: UITextView!
    @IBOutlet weak var projectCompletionDatePicker: UIDatePicker!
    
    @IBOutlet weak var builderTextView: UITextView!
    @IBOutlet weak var applicatorTextView: UITextView!
    @IBOutlet weak var painterTextView: UITextView!
    @IBOutlet weak var substrateTextView: UITextView!
    @IBOutlet weak var systemTextView: UITextView!
    @IBOutlet weak var jobSizeTextView: UITextView!
    @IBOutlet weak var costOfBuildTextView: UITextView!
    @IBOutlet weak var extraInfoTextView: UITextView!
    
    @IBOutlet weak var nextButton: UIButton!

    // MARK: - Actions
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "ImageUploadScreen", sender: nil)
    }
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.imageView?.contentMode = .scaleAspectFit
        
        projectCompletionDatePicker.setValue(UIColor.black, forKey: "textColor")
        projectCompletionDatePicker.backgroundColor = .white
        
        projectNameTextView.delegate = self
        projectAddrTextView.delegate = self
        projectBgTextView.delegate = self
        customerNameTextView.delegate = self
        customerPhoneTextView.delegate = self
        customerEmailTextView.delegate = self
        
        builderTextView.delegate = self
        applicatorTextView.delegate = self
        painterTextView.delegate = self
        substrateTextView.delegate = self
        systemTextView.delegate = self
        jobSizeTextView.delegate = self
        costOfBuildTextView.delegate = self
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ImageUploadScreen" {
            let destinationVC = segue.destination as! ImageAttachVC
            destinationVC.projectName = projectNameTextView.text
            destinationVC.projectAddr = projectAddrTextView.text
            destinationVC.projectBg = projectBgTextView.text
            destinationVC.customerName = customerNameTextView.text
            destinationVC.customerPhone = customerPhoneTextView.text
            destinationVC.customerEmail = customerEmailTextView.text
            
            // get date from date picker
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, YYYY"
            destinationVC.projectCompletionDate = dateFormatter.string(from: projectCompletionDatePicker.date)
            
            destinationVC.builder = builderTextView.text
            destinationVC.applicator = applicatorTextView.text
            destinationVC.painter = painterTextView.text
            destinationVC.substrate = substrateTextView.text
            destinationVC.system = systemTextView.text
            destinationVC.jobSize = jobSizeTextView.text
            destinationVC.costOfBuild = costOfBuildTextView.text
            destinationVC.extraInfo = extraInfoTextView.text
        }
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
        if !costOfBuildTextView.isFirstResponder &&
            !extraInfoTextView.isFirstResponder {
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

