//
//  ImageAttachVC.swift
//  QuickReport
//
//  Created by Atikur Rahman on 19/4/18.
//  Copyright © 2018 Atikur Rahman. All rights reserved.
//

import UIKit
//import MessageUI

class ImageAttachVC: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var cameraButton: UIButton!
    
    var comments = [String]()
    
    var images = [UIImage]()
    var selectedImage = UIImage()
    
    // MARK: - Actions
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self
        
        let alert = UIAlertController(title: "Upload Photo", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Use Camera", style: .default, handler: { _ in
            picker.sourceType = .camera
            self.present(picker, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Use Camera Roll", style: .default, handler: { _ in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    private func addImageToUploadCollection(image: UIImage) {
        images.append(image)
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "ShowTextInput", sender: nil)
    }
    
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeKeyboardNotifications()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTextInput" {
            let destinationVC = segue.destination as! TextInputVC
            destinationVC.comments = comments
            destinationVC.images = images
        } else if segue.identifier == "ImageAdded" {
            let destVC = segue.destination as! ImageAddedVC
            destVC.image = selectedImage
            destVC.isSalesRepLearningImage = false
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

extension ImageAttachVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        
        addImageToUploadCollection(image: image)
        selectedImage = image
//        if picker.sourceType == .camera {
//            UIImageWriteToSavedPhotosAlbum(image, self, Selector(("image:didFinishSavingWithError:contextInfo:")), nil)
//        } else {
        dismiss(animated: true)
        performSegue(withIdentifier: "ImageAdded", sender: nil)
//        }
        
    }
    
//    func image(image: UIImage, didFinishSavingWithError error:NSError?, contextInfo: UnsafeRawPointer) {
//        guard error == nil else {
//            // Error saving image
//            return
//        }
//        // Image saved successfully
//
//        dismiss(animated: true)
//        performSegue(withIdentifier: "ImageAdded", sender: nil)
//    }
}

extension ImageAttachVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
