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
                vc.projectNameTextView.text = ""
                vc.projectAddrTextView.text = ""
                vc.projectBgTextView.text = ""
                vc.customerNameTextView.text = ""
                vc.customerPhoneTextView.text = ""
                vc.customerEmailTextView.text = ""
                
                vc.builderTextView.text = ""
                vc.applicatorTextView.text = ""
                vc.painterTextView.text = ""
                vc.substrateTextView.text = ""
                vc.systemTextView.text = ""
                vc.jobSizeTextView.text = ""
                vc.costOfBuildTextView.text = ""
                vc.extraInfoTextView.text = ""
            }
            
            self.navigationController!.popToRootViewController(animated: true)
        }
    }
}
