//
//  ImageAttachVC.swift
//  QuickReport
//
//  Created by Atikur Rahman on 19/4/18.
//  Copyright © 2018 Atikur Rahman. All rights reserved.
//

import UIKit
import MessageUI

class ImageAttachVC: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var imageDescriptionTextView: UITextView!
    
    var projectName: String?
    var builder: String?
    var applicator: String?
    var painter: String?
    var substrate: String?
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        
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
        
        sendEmail(messageText: messageText)
    }
    
    func sendEmail(messageText: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["atik.bd08@gmail.com"])
//            mail.addAttachmentData(UIImageJPEGRepresentation(UIImage(named: "emailImage")!, CGFloat(1.0))!, mimeType: "image/jpeg", fileName:  "test.jpeg")
            
            mail.setMessageBody(messageText, isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if result == .sent {
            previewImageView.image = UIImage(named: "confirmation")
        }
        
        controller.dismiss(animated: true)
    }

}
