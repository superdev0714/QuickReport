//
//  ConfirmationVC.swift
//  QuickReport
//
//  Created by Atikur Rahman on 23/4/18.
//  Copyright © 2018 Atikur Rahman. All rights reserved.
//

import UIKit

class ConfirmationVC: UIViewController {
    
    @IBOutlet weak var confirmLabel: UILabel!
    
    var isSalesRepLearningEmail: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let isSalesRepLearningEmail = isSalesRepLearningEmail {
            if isSalesRepLearningEmail {
                confirmLabel.text = "LEARNINGS SUBMITTED"
            } else {
                confirmLabel.text = "CASE STUDY SUBMITTED"
            }
        }
        
        self.navigationItem.setHidesBackButton(true, animated:true);
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.navigationController!.popToRootViewController(animated: true)
        }
    }
}
