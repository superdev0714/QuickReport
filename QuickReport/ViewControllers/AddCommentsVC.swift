//
//  AddCommentsVC.swift
//  QuickReport
//
//  Created by dev on 10/16/18.
//  Copyright © 2018 Atikur Rahman. All rights reserved.
//

import UIKit

class AddCommentsVC: UIViewController {
    
    var image = UIImage()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var txtComment: UITextView!
    @IBOutlet weak var btnSave: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        btnSave.layer.borderWidth = 2.0
        btnSave.layer.cornerRadius = 5.0
        btnSave.layer.borderColor = UIColor.white.cgColor
        
        imageView.image = image
        
        txtComment.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeKeyboardNotifications()
    }
    

    @IBAction func saveButtonPressed(_ sender: Any) {
        if let navController = self.navigationController, navController.viewControllers.count >= 3 {
            if let vc = navController.viewControllers[navController.viewControllers.count - 3] as? ImageAttachVC {
                vc.comments.append(txtComment.text)
                self.navigationController!.popToViewController(vc, animated: true)
            } else if let vc = navController.viewControllers[navController.viewControllers.count - 3] as? SalesRepImageAttachVC {
                vc.comments.append(txtComment.text)
                self.navigationController!.popToViewController(vc, animated: true)
            }
        }
    }
    
    // MARK: - Subscribe/unsubscribe keyboard notifications
    
    private func subscribeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: .UIKeyboardWillHide, object: nil)
    }
    
    private func unsubscribeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self,
                                                  name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: .UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - Handle keyboard notifications
    
    @objc func keyboardWillShow(notification: NSNotification) {
        // don't move the view for first three textViews
        if !txtComment.isFirstResponder &&
            !txtComment.isFirstResponder {
            return
        }
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

extension AddCommentsVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
