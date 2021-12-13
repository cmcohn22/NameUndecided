//
//  SettingsUserVC.swift
//  swiftChatter
//
//  Created by Griffin Kaufman on 12/11/21.
//  Copyright © 2021 The Regents of the University of Michigan. All rights reserved.
//

import Foundation
import UIKit

final class SettingsUserVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var first_name_label: UILabel!
    @IBOutlet weak var username_label: UILabel!
    @IBOutlet weak var last_name_label: UILabel!
    @IBOutlet weak var email_label: UILabel!

    @IBOutlet weak var postImage: UIImageView!
    
    @IBAction func pickMedia(_ sender: Any) {
        presentPicker(.photoLibrary)
    }

    
    @IBAction func changeProfilePic(_ sender: Any) {
        UserStore.shared.changeProImg(imageIn: postImage.image)
    }
    @IBAction func accessCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            presentPicker(.camera)
        } else {
            print("Camera not available. iPhone simulators don't simulate the camera.")
        }
    }
    
        
    private func presentPicker(_ sourceType: UIImagePickerController.SourceType) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = sourceType
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true
            imagePickerController.mediaTypes = ["public.image"]
            present(imagePickerController, animated: true, completion: nil)
        }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any]) {
            if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String {
                if mediaType  == "public.image" {
                    postImage.image = (info[UIImagePickerController.InfoKey.editedImage] as? UIImage ??
                                        info[UIImagePickerController.InfoKey.originalImage] as? UIImage)?
                        .resizeImage(targetSize: CGSize(width: 265, height: 174))
                }
            }
            picker.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.first_name_label.text = UserStore.shared.activeUser.first_name
        self.last_name_label.text = UserStore.shared.activeUser.last_name
        self.username_label.text = UserStore.shared.activeUser.username
        self.email_label.text = UserStore.shared.activeUser.email
    }
//        first_name_label.text = SettingsUser.shared.settings.firstnameU
//        last_name_label.text = SettingsUser.shared.settings.lastnameU
//        username_label.text = SettingsUser.shared.settings.usernameU
//        email_label.text = SettingsUser.shared.settings.emailU
}
