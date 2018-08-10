//
//  StartMenuVC.swift
//  QuickReport
//
//  Created by Atikur Rahman on 9/8/18.
//  Copyright © 2018 Atikur Rahman. All rights reserved.
//

import UIKit

class StartMenuVC: UIViewController {
    
    let keyName = "uname"
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var caseStudyButton: UIButton!
    @IBOutlet weak var salesRepButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        caseStudyButton.layer.borderWidth = 2.0
        caseStudyButton.layer.cornerRadius = 5.0
        caseStudyButton.layer.borderColor = UIColor.white.cgColor
        
        salesRepButton.layer.borderWidth = 2.0
        salesRepButton.layer.cornerRadius = 5.0
        salesRepButton.layer.borderColor = UIColor.white.cgColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let uname = defaults.string(forKey: keyName) {
            print("hello \(uname)")
        } else {
            print("show alert to set user name.")
            getUserNameAlert()
        }
    }
    
    // MARK: - Username input
    
    private func getUserNameAlert() {
        let alert = UIAlertController(title: "Enter your name", message: nil, preferredStyle: .alert)
        alert.addTextField {
            textField in
            textField.placeholder = "Your Name"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {[weak alert] (_)in
            guard let textField = alert?.textFields?.first else {
                return
            }
            
            guard let name = textField.text, !name.isEmpty else {
                // keep showing alert until username is provided
                self.getUserNameAlert()
                return
            }
            
            self.defaults.set(name, forKey: self.keyName)
        }))
        
        present(alert, animated: true)
    }
    
}
