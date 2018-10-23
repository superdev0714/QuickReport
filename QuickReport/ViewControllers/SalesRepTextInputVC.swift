//
//  SalesRepTextInputVC.swift
//  QuickReport
//
//  Created by Atikur Rahman on 10/8/18.
//  Copyright © 2018 Atikur Rahman. All rights reserved.
//

import UIKit
import MessageUI

class SalesRepTextInputVC: UIViewController {
    
    var comments = [String]()
    var typesOfLearning = [String]()
    var images = [UIImage]()
    
    @IBOutlet weak var typeOfLearningPicker: UIPickerView!
    @IBOutlet weak var learningTextView: UITextView!
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        let alertMsg = "Your email app will now open. Please click ‘send’ in the email for the learnings to be submitted to the Marketing department"
        
        let alert = UIAlertController(title: nil, message: alertMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in
            self.startEmailSendingProcess()
        }))
        present(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typesOfLearning = [
            "Customers",
            "Products",
            "Competitors",
            "Substrates",
            "Other"
        ]
        
        typeOfLearningPicker.delegate = self
        typeOfLearningPicker.dataSource = self
        
        typeOfLearningPicker.setValue(UIColor.black, forKey: "textColor")
        typeOfLearningPicker.backgroundColor = .white
        
        learningTextView.delegate = self
        learningTextView.text = "Enter Your Learnings Here"
        learningTextView.textColor = UIColor.lightGray
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter Your Learning Here"
            textView.textColor = UIColor.lightGray
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmailSent" {
            let destVC = segue.destination as! ConfirmationVC
            destVC.isSalesRepLearningEmail = true
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
    
    private func startEmailSendingProcess() {
        let defaults = UserDefaults.standard
        let email = defaults.string(forKey: "uemail") ?? "unknown"
      
        guard let typeOfLearning = typesOfLearning[typeOfLearningPicker.selectedRow(inComponent: 0)] as? String ,
            let learning = learningTextView.text else {
                return
        }
        
        var messageText = """
        <p><b>Type of Learning: </b>\(typeOfLearning)</p>
        <p><b>Learning: </b>\(learning)</p>
        """
        
        var index = 1
        for strComment in comments {
            messageText += "<p>Photo\(index): \(strComment)</p>"
            index += 1
        }
        
        messageText += "<p>Submitted By: \(email)</p>"
        
        sendEmail(messageText: messageText, images: images)
    }
    
    // MARK: - Send email
    
    private func sendEmail(messageText: String, images: [UIImage]) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            let salesRecipients = [
                "insights@acratex.com.au"
                ]
            mail.setToRecipients(salesRecipients)
            
            var image_count = 1
            for image in images {
                mail.addAttachmentData(UIImageJPEGRepresentation(image, CGFloat(1.0))!, mimeType: "image/jpeg", fileName: "image\(image_count).jpeg")
                image_count += 1
            }
            
            mail.setSubject("SALES REP LEARNING")
            mail.setMessageBody(messageText, isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
            print("Email send failed.")
            let alertMsg = "Email send failed."
            
            let alert = UIAlertController(title: nil, message: alertMsg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
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

extension SalesRepTextInputVC: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if result == .sent {
            performSegue(withIdentifier: "EmailSentSuccess", sender: nil)
        }
        
        controller.dismiss(animated: true)
    }
}
