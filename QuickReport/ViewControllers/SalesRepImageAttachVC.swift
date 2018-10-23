//
//  SalesRepImageAttachVC.swift
//  QuickReport
//
//  Created by Atikur Rahman on 10/8/18.
//  Copyright © 2018 Atikur Rahman. All rights reserved.
//

import UIKit


class SalesRepImageAttachVC: UIViewController {
    
    var comments = [String]()
    var images = [UIImage]()
    var selectedImage = UIImage()
    
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
        performSegue(withIdentifier: "SalesRepShow", sender: nil)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SalesRepShow" {
            let destVC = segue.destination as! SalesRepTextInputVC
            destVC.comments = comments
            destVC.images = images
        } else if segue.identifier == "ImageAdded" {
            let destVC = segue.destination as! ImageAddedVC
            destVC.image = selectedImage
            destVC.isSalesRepLearningImage = true
        }
    }
}

extension SalesRepImageAttachVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        
        addImageToUploadCollection(image: image)
        selectedImage = image
        
        dismiss(animated: true)
        performSegue(withIdentifier: "ImageAdded", sender: nil)
    }
    
}
