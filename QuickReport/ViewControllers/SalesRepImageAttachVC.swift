//
//  SalesRepImageAttachVC.swift
//  QuickReport
//
//  Created by Atikur Rahman on 10/8/18.
//  Copyright © 2018 Atikur Rahman. All rights reserved.
//

import UIKit
import MessageUI

class SalesRepImageAttachVC: UIViewController {
    
    var typeOfLearning: String?
    var learning: String?
    
    var images = [UIImage]()
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        let alert = UIAlertController(title: "Upload Photo", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Use Camera", style: .default, handler: { _ in
            picker.sourceType = .camera
            self.present(picker, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Use Camera Roll", style: .default, handler: { _ in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true)
        }))
        present(alert, animated: true)
    }
    
    private func addImageToUploadCollection(image: UIImage) {
        images.append(image)
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        let alertMsg = "Your email app will now open. Please click ‘send’ in the email for the learnings to be submitted to the Marketing department"
        
        let alert = UIAlertController(title: nil, message: alertMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in
            self.startEmailSendingProcess()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func startEmailSendingProcess() {
        let defaults = UserDefaults.standard
        let username = defaults.string(forKey: "uname") ?? "unknown"
        
        guard let typeOfLearning = typeOfLearning,
            let learning = learning else {
                return
        }
        
        var messageText = """
        <p><b>Type of Learning: </b>\(typeOfLearning)</p>
        <p><b>Learning: </b>\(learning)</p>
        """
        
        messageText += "<p>Submitted By: \(username)</p>"
        
        sendEmail(messageText: messageText, images: images)
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
            
            mail.setSubject("Learning")
            mail.setMessageBody(messageText, isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
            print("Email send failed.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmailSent" {
            let destVC = segue.destination as! ConfirmationVC
            destVC.isSalesRepLearningEmail = true
        } else if segue.identifier == "ImageAdded" {
            let destVC = segue.destination as! ImageAddedVC
            destVC.isSalesRepLearningImage = true
        }
    }
}

extension SalesRepImageAttachVC: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if result == .sent {
            performSegue(withIdentifier: "EmailSent", sender: nil)
        }
        
        controller.dismiss(animated: true)
    }
}

extension SalesRepImageAttachVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        
        addImageToUploadCollection(image: image)
        
        dismiss(animated: true)
        performSegue(withIdentifier: "ImageAdded", sender: nil)
    }
}
