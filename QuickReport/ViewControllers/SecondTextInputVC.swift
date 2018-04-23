//
//  SecondTextInputVC.swift
//  QuickReport
//
//  Created by Atikur Rahman on 23/4/18.
//  Copyright © 2018 Atikur Rahman. All rights reserved.
//

import UIKit

class SecondTextInputVC: UIViewController {
    
    @IBOutlet weak var builderTextView: UITextView!
    @IBOutlet weak var applicatorTextView: UITextView!
    @IBOutlet weak var painterTextView: UITextView!
    @IBOutlet weak var substrateTextView: UITextView!
    @IBOutlet weak var systemTextView: UITextView!
    @IBOutlet weak var jobSizeTextView: UITextView!
    @IBOutlet weak var extraInfoTextView: UITextView!
    
    var projectName: String?
    var projectAddr: String?
    var projectBg: String?
    var customerName: String?
    var customerPhone: String?
    var customerEmail: String?
    var projectCompletionDate: String?
    
    @IBAction func nextButtonPressed(_ sender: Any) {
    }
}
