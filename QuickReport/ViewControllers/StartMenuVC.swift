//
//  StartMenuVC.swift
//  QuickReport
//
//  Created by Atikur Rahman on 9/8/18.
//  Copyright © 2018 Atikur Rahman. All rights reserved.
//

import UIKit

class StartMenuVC: UIViewController {
    
    let keyEmail = "uemail"
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var caseStudyButton: UIButton!
    @IBOutlet weak var salesRepButton: UIButton!
    @IBOutlet weak var glisButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        caseStudyButton.layer.borderWidth = 2.0
        caseStudyButton.layer.cornerRadius = 5.0
        caseStudyButton.layer.borderColor = UIColor.white.cgColor
        
        salesRepButton.layer.borderWidth = 2.0
        salesRepButton.layer.cornerRadius = 5.0
        salesRepButton.layer.borderColor = UIColor.white.cgColor
        
        glisButton.layer.borderWidth = 2.0
        glisButton.layer.cornerRadius = 5.0
        glisButton.layer.borderColor = UIColor.white.cgColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let uemail = defaults.string(forKey: keyEmail) {
            print("hello \(uemail)")
        } else {
            print("show alert to set user email.")
            getUserEmailAlert()
        }
    }
    
    // MARK: - User email input
    
    private func getUserEmailAlert() {
        let alert = UIAlertController(title: "Enter your email address", message: nil, preferredStyle: .alert)
        alert.addTextField {
            textField in
            textField.placeholder = "Your Email Address"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {[weak alert] (_)in
            guard let textField = alert?.textFields?.first else {
                return
            }
            
            guard let name = textField.text, !name.isEmpty else {
                // keep showing alert until username is provided
                self.getUserEmailAlert()
                return
            }
            
            if (!self.isValidEmail(testStr: name)) {
                self.getUserEmailAlert()
                return
            }
            
            self.defaults.set(name, forKey: self.keyEmail)
        }))
        
        present(alert, animated: true)
    }
    
    private func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
}
