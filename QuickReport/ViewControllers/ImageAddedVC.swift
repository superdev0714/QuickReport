//
//  ImageAddedVC.swift
//  QuickReport
//
//  Created by Atikur Rahman on 28/4/18.
//  Copyright © 2018 Atikur Rahman. All rights reserved.
//

import UIKit

class ImageAddedVC: UIViewController {
    
    var isSalesRepLearningImage: Bool?
    
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let isSalesRepLearningImage = isSalesRepLearningImage {
            if isSalesRepLearningImage {
                submitButton.setTitle("SUBMIT LEARNINGS", for: .normal)
            } else {
                submitButton.setTitle("SUBMIT CASE STUDY", for: .normal)
            }
        }
        
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
