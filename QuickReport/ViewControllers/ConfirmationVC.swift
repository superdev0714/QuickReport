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
            self.navigationController!.popToRootViewController(animated: true)
        }
    }
}
