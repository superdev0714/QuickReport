//
//  ViewController.swift
//  QuickReport
//
//  Created by Atikur Rahman on 18/4/18.
//  Copyright © 2018 Atikur Rahman. All rights reserved.
//

import UIKit
import MessageUI

class ViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var projectNameTextView: UITextView!
    @IBOutlet weak var builderTextView: UITextView!
    @IBOutlet weak var applicatorTextView: UITextView!
    @IBOutlet weak var painterTextView: UITextView!
    @IBOutlet weak var substrateTextView: UITextView!
    
    let keyName = "uname"
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
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
    
    @IBAction func sendMail(_ sender: Any) {
        composeMail()
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
        }))
        
        present(alert, animated: true)
    }

    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["atik.bd08@gmail.com"])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func composeMail() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            
            mailComposeVC.mailComposeDelegate = self
            mailComposeVC.setToRecipients(["atik.bd08@gmail.com"])
            
            mailComposeVC.addAttachmentData(UIImageJPEGRepresentation(UIImage(named: "emailImage")!, CGFloat(1.0))!, mimeType: "image/jpeg", fileName:  "test.jpeg")
            
            mailComposeVC.setSubject("Email Subject")
            
            mailComposeVC.setMessageBody("<html><body><p>This is your message</p></body></html>", isHTML: true)
            
            self.present(mailComposeVC, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        print(result.rawValue)
        print(error)
        controller.dismiss(animated: true)
    }

}

