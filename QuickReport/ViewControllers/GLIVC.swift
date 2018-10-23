//
//  GLIVC.swift
//  QuickReport
//
//  Created by AV on 10/16/18.
//  Copyright © 2018 Atikur Rahman. All rights reserved.
//

import UIKit
import MessageUI

class GLIVC: UIViewController {

    @IBOutlet weak var incidentDatePicker: UIDatePicker!
    @IBOutlet weak var incidentTimePicker: UIDatePicker!
    @IBOutlet weak var txtDescription: UITextView!
    
    @IBOutlet weak var btnNext: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnNext.imageView?.contentMode = .scaleAspectFit
        
        incidentDatePicker.setValue(UIColor.black, forKey: "textColor")
        incidentDatePicker.backgroundColor = .white
        
        incidentTimePicker.setValue(UIColor.black, forKey: "textColor")
        incidentTimePicker.backgroundColor = .white
        
        txtDescription.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeKeyboardNotifications()
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
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
//
        // get date from date picker
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, YYYY"
        let incidentDate = dateFormatter.string(from: incidentDatePicker.date)
        dateFormatter.dateFormat = "HH:mm:ss"
        let incidentTime = dateFormatter.string(from: incidentTimePicker.date)
        
        guard let descriptionText = txtDescription.text else {
                return
        }
        
        var messageText = """
        <p><b>Incident Date: </b>\(incidentDate)</p>
        <p><b>Incident Time: </b>\(incidentTime)</p>
        <p><b>Description: </b>\(descriptionText)</p>
        """
        
        messageText += "<p>Report By: \(email)</p>"
        
        sendEmail(messageText: messageText)
    }
    
    // MARK: - Send email
    
    private func sendEmail(messageText: String) {
        if MFMailComposeViewController.canSendMail() {
            let defaults = UserDefaults.standard
            let email = defaults.string(forKey: "uemail") ?? "unknown"
            let recipientsList = [email]
            
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(recipientsList)
            
            mail.setSubject("GLI")
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
        if !txtDescription.isFirstResponder {
            return
        }
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - 100
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
   
   
}

extension GLIVC: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if result == .sent {
            performSegue(withIdentifier: "EmailSent", sender: nil)
        }
        
        controller.dismiss(animated: true)
    }
}

extension GLIVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

