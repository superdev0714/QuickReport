//
//  TextInputVC.swift
//  QuickReport
//
//  Created by Atikur Rahman on 18/4/18.
//  Copyright © 2018 Atikur Rahman. All rights reserved.
//

import UIKit
import MessageUI

class TextInputVC: UIViewController {
    
    var substrates = [String]()
    var comments = [String]()
    // MARK: - Properties
    
    @IBOutlet weak var projectNameTextView: UITextView!
    @IBOutlet weak var projectAddrTextView: UITextView!
    @IBOutlet weak var projectCompletionDatePicker: UIDatePicker!
    @IBOutlet weak var builderTextView: UITextView!
    @IBOutlet weak var customerNameTextView: UITextView!
    @IBOutlet weak var customerPhoneTextView: UITextView!
    @IBOutlet weak var substratePickerView: UIPickerView!
    @IBOutlet weak var productsUsedTextView: UITextView!
    @IBOutlet weak var projectStoryTextView: UITextView!
    
    @IBOutlet weak var submitButton: UIButton!
    
    var images = [UIImage]()

    // MARK: - Actions
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        let alertMsg = "Your email app will now open. Please click ‘send’ in the email for the case study to be submitted to the Marketing department"
        
        let alert = UIAlertController(title: nil, message: alertMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in
            self.startEmailSendingProcess()
        }))
        present(alert, animated: true, completion: nil)
        
    }
    
    private func startEmailSendingProcess() {
        let defaults = UserDefaults.standard
        let email = defaults.string(forKey: "uemail") ?? "unknown"
        
        // get date from date picker
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, YYYY"
        let projectCompletionDate = dateFormatter.string(from: projectCompletionDatePicker.date)
                
        guard let projectName = projectNameTextView.text,
            let projectAddr = projectAddrTextView.text,
            let customerName = customerNameTextView.text,
            let customerPhone = customerPhoneTextView.text,
            let builder = builderTextView.text,
            let substrate = substrates[substratePickerView.selectedRow(inComponent: 0)] as? String,
            let productsUsed = productsUsedTextView.text,
            let projectStory = projectStoryTextView.text else {
                return
        }
        var messageText = """
        <p><b>Project Name: </b>\(projectName)</p>
        <p><b>Project address: </b>\(projectAddr)</p>
        <p><b>Project completion date: </b>\(projectCompletionDate)</p>
        <p><b>Customer name (Asset Owner): </b>\(customerName)</p>
        <p><b>Customer phone: </b>\(customerPhone)</p>
        <p><b>Builder: </b>\(builder)</p>
        <p><b>Substrate: </b>\(substrate)</p>
        <p><b>Products Used: </b>\(productsUsed)</p>
        <p><b>Project Story: </b>\(projectStory)</p>
        """
        var index = 1
        for strComment in comments {
            messageText += "<p>Photo\(index): \(strComment)</p>"
            index += 1
        }
        
        messageText += "<p>Report By: \(email)</p>"
        
        sendEmail(messageText: messageText, images: images)
    }
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitButton.imageView?.contentMode = .scaleAspectFit
        
        projectCompletionDatePicker.setValue(UIColor.black, forKey: "textColor")
        projectCompletionDatePicker.backgroundColor = .white
        
        substrates = [
            "Masonry",
            "AAC",
            "EIFS(Exsulite & Similar)",
            "Tilt-up Concrete",
            "PVC Permanent Formwork",
            "Fibre Cement",
            "Fibre Cement Permanent Formwork",
            "Other",
        ]
        
        substratePickerView.delegate = self
        substratePickerView.dataSource = self
        
        projectNameTextView.delegate = self
        projectAddrTextView.delegate = self
        customerNameTextView.delegate = self
        customerPhoneTextView.delegate = self
        
        builderTextView.delegate = self
        productsUsedTextView.delegate = self
        projectStoryTextView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeKeyboardNotifications()
    }
    
    // MARK: - Send email
    
    private func sendEmail(messageText: String, images: [UIImage]) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(recipients)
            
            var image_count = 1
            for image in images {
                mail.addAttachmentData(UIImageJPEGRepresentation(image, CGFloat(1.0))!, mimeType: "image/jpeg", fileName: "image\(image_count).jpeg")
                image_count += 1
            }
            
            mail.setSubject("CASE STUDY")
            mail.setMessageBody(messageText, isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
            print("Email send failed.")
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
        if !productsUsedTextView.isFirstResponder &&
            !projectStoryTextView.isFirstResponder {
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


extension TextInputVC: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if result == .sent {
            performSegue(withIdentifier: "EmailSent", sender: nil)
        }
        
        controller.dismiss(animated: true)
    }
}

extension TextInputVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return substrates.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return substrates[row]
    }
}
