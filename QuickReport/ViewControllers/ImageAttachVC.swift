//
//  ImageAttachVC.swift
//  QuickReport
//
//  Created by Atikur Rahman on 19/4/18.
//  Copyright © 2018 Atikur Rahman. All rights reserved.
//

import UIKit
import MessageUI

class ImageAttachVC: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var imageDescriptionTextView: UITextView!
    
    var projectName: String?
    var projectAddr: String?
    var projectBg: String?
    var customerName: String?
    var customerPhone: String?
    var customerEmail: String?
    var projectCompletionDate: String?
    
    var builder: String?
    var applicator: String?
    var painter: String?
    var substrate: String?
    var system: String?
    var jobSize: String?
    var extraInfo: String?
    
    var images = [UIImage]()
    var descriptions = [String]()
    
    let defaultDescription = "Description of photo"
    
    // MARK: - Actions
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        addImageToUploadCollection()
        
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func addImageToUploadCollection() {
        if let image = previewImageView.image {
            images.append(image)
            
            let description = imageDescriptionTextView.text ?? defaultDescription + " \(descriptions.count): "
            descriptions.append(description)
            
            previewImageView.image = nil
            imageDescriptionTextView.text = defaultDescription + " \(descriptions.count + 1): "
        }
    }
    
    @IBAction func uploadButtonPressed(_ sender: Any) {
        let defaults = UserDefaults.standard
        let username = defaults.string(forKey: "uname") ?? "unknown"
        
        addImageToUploadCollection()
        
        guard let projectName = projectName,
            let projectAddr = projectAddr,
            let projectBg = projectBg,
            let customerName = customerName,
            let customerPhone = customerPhone,
            let customerEmail = customerEmail,
            let projectCompletionDate = projectCompletionDate,
            let builder = builder,
            let applictor = applicator,
            let painter = painter,
            let substrate = substrate,
            let system = system,
            let jobSize = jobSize,
            let extraInfo = extraInfo else {
                return
        }
        var messageText = """
            <p>\(projectName)</p>
            <p>\(projectAddr)</p>
            <p>\(projectBg)</p>
            <p>\(customerName)</p>
            <p>\(customerPhone)</p>
            <p>\(customerEmail)</p>
            <p>\(projectCompletionDate)</p>
            <p>\(builder)</p>
            <p>\(applictor)</p>
            <p>\(painter)</p>
            <p>\(substrate)</p>
            <p>\(system)</p>
            <p>\(jobSize)</p>
            <p>\(extraInfo)</p>
        """
        
        for description in descriptions {
            messageText += "<p>\(description)</p>"
        }
        
        messageText += "<p>Report By: \(username)</p>"
        
        sendEmail(messageText: messageText, images: images)
    }
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageDescriptionTextView.delegate = self
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
            
            mail.setSubject("Report")
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

extension ImageAttachVC: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if result == .sent {
            performSegue(withIdentifier: "EmailSent", sender: nil)
        }
        
        controller.dismiss(animated: true)
    }
}

extension ImageAttachVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        
        previewImageView.image = image
        
        dismiss(animated: true)
    }
}

extension ImageAttachVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
