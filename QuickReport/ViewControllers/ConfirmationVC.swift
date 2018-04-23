//
//  ConfirmationVC.swift
//  QuickReport
//
//  Created by Atikur Rahman on 23/4/18.
//  Copyright © 2018 Atikur Rahman. All rights reserved.
//

import UIKit

class ConfirmationVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated:true);
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            if let vc = self.navigationController?.viewControllers.first as? TextInputVC {
                vc.projectNameTextView.text = "Project Name: "
                vc.applicatorTextView.text = "Applicator: "
                vc.builderTextView.text = "Builder: "
                vc.painterTextView.text = "Painter: "
                vc.substrateTextView.text = "Substrate: "
                vc.systemTextView.text = "System: "
                vc.jobSizeTextView.text = "Job size (sqm): "
                //vc.extraInfoTextView.text = "Extra information (challenges, solutions, anything unique?): "
            }
            
            self.navigationController!.popToRootViewController(animated: true)
        }
    }
}
