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
    var builder: String?
    var applicator: String?
    var painter: String?
    var substrate: String?
    
    // MARK: - Actions
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func uploadButtonPressed(_ sender: Any) {
        guard let projectName = projectName,
            let builder = builder,
            let applictor = applicator,
            let painter = painter,
            let substrate = substrate,
            let imageDescription = imageDescriptionTextView.text else {
                return
        }
        let messageText = """
            <p>\(projectName)</p>
            <p>\(builder)</p>
            <p>\(applictor)</p>
            <p>\(painter)</p>
            <p>\(substrate)</p>
            <p>\(imageDescription)</p>
        """
        
        sendEmail(messageText: messageText, image: previewImageView.image)
    }
    
    // MARK: - Send email
    
    private func sendEmail(messageText: String, image: UIImage?) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["atik.bd08@gmail.com"])
            
            if let image = image {
                mail.addAttachmentData(UIImageJPEGRepresentation(image, CGFloat(1.0))!, mimeType: "image/jpeg", fileName: "image1.jpeg")
            }
            
            mail.setMessageBody(messageText, isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
            print("Email send failed.")
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
