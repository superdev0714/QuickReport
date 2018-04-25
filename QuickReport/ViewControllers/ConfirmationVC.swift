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
//                vc.projectNameTextView.text = "Project Name: "
//                vc.projectAddrTextView.text = "Project address: "
//                vc.projectBgTextView.text = "Project background: "
//                vc.customerNameTextView.text = "Customer name: "
//                vc.customerPhoneTextView.text = "Customer phone: "
//                vc.customerEmailTextView.text = "Customer email: "
//                vc.projectCompletionDateTextView.text = "Project completion date: "
            }
            
            self.navigationController!.popToRootViewController(animated: true)
        }
    }
}
