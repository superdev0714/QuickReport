//
//  ImageAddedVC.swift
//  QuickReport
//
//  Created by Atikur Rahman on 28/4/18.
//  Copyright © 2018 Atikur Rahman. All rights reserved.
//

import UIKit

class ImageAddedVC: UIViewController {
    
    @IBAction func deletePreviousButtonPressed(_ sender: Any) {
        if let navController = self.navigationController, navController.viewControllers.count >= 2 {
            if let vc = navController.viewControllers[navController.viewControllers.count - 2] as? ImageAttachVC {
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
            }
        }
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        if let navController = self.navigationController, navController.viewControllers.count >= 2 {
            if let vc = navController.viewControllers[navController.viewControllers.count - 2] as? ImageAttachVC {
                self.navigationController!.popViewController(animated: true)
                vc.uploadButtonPressed(sender)
            }
        }        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated:true)
    }
}
