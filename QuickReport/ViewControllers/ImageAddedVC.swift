//
//  ImageAddedVC.swift
//  QuickReport
//
//  Created by Atikur Rahman on 28/4/18.
//  Copyright © 2018 Atikur Rahman. All rights reserved.
//

import UIKit

class ImageAddedVC: UIViewController {
    
    var isSalesRepLearningImage = false
    
    @IBOutlet weak var deletePreviousButton: UIButton!
    @IBOutlet weak var uploadAnotherButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isSalesRepLearningImage {
            submitButton.setTitle("SUBMIT LEARNINGS", for: .normal)
        } else {
            submitButton.setTitle("SUBMIT CASE STUDY", for: .normal)
        }
        
        deletePreviousButton.layer.borderWidth = 2.0
        deletePreviousButton.layer.cornerRadius = 5.0
        deletePreviousButton.layer.borderColor = UIColor.white.cgColor
        
        uploadAnotherButton.layer.borderWidth = 2.0
        uploadAnotherButton.layer.cornerRadius = 5.0
        uploadAnotherButton.layer.borderColor = UIColor.white.cgColor
        
        submitButton.layer.borderWidth = 2.0
        submitButton.layer.cornerRadius = 5.0
        submitButton.layer.borderColor = UIColor.white.cgColor
        
        self.navigationItem.setHidesBackButton(true, animated:true)
    }
    
    @IBAction func deletePreviousButtonPressed(_ sender: Any) {
        if let navController = self.navigationController, navController.viewControllers.count >= 2 {
            if let vc = navController.viewControllers[navController.viewControllers.count - 2] as? ImageAttachVC {
                vc.images = []
            } else if let vc = navController.viewControllers[navController.viewControllers.count - 2] as? SalesRepImageAttachVC {
                vc.images = []
            }
        }
        
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func uploadAnotherButtonPressed(_ sender: Any) {
        if let navController = self.navigationController, navController.viewControllers.count >= 2 {
            if let vc = navController.viewControllers[navController.viewControllers.count - 2] as? ImageAttachVC {
                self.navigationController!.popViewController(animated: true)
                vc.cameraButtonPressed(sender)
            } else if let vc = navController.viewControllers[navController.viewControllers.count - 2] as? SalesRepImageAttachVC {
                self.navigationController!.popViewController(animated: true)
                vc.cameraButtonPressed(sender)
            }
        }
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        if let navController = self.navigationController, navController.viewControllers.count >= 2 {
            if let vc = navController.viewControllers[navController.viewControllers.count - 2] as? ImageAttachVC {
                self.navigationController!.popViewController(animated: true)
                vc.uploadButtonPressed(sender)
            } else if let vc = navController.viewControllers[navController.viewControllers.count - 2] as? SalesRepImageAttachVC {
                self.navigationController!.popViewController(animated: true)
                vc.submitButtonPressed(sender)
            }
        }        
    }
}
