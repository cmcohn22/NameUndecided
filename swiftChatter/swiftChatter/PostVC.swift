//
//  PostVC.swift
//  swiftChatter
//
//  Created by sugih on 7/24/20.
//  Copyright © 2020 The Regents of the University of Michigan. All rights reserved.
//
import UIKit

final class PostVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var chattname: UITextField!
    @IBOutlet weak var chattdescription: UITextField!
    @IBAction func submitNewChatt(_ sender: Any) {
        let chatt = Chatt(name: self.chattname.text,
                             description: self.chattdescription.text,
                             lat: nil,
                             long: nil,
                             radius: nil)
        
        ChattStore.shared.createChatt(chatt, image: postImage.image)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var postImage: UIImageView!
    
        
    @IBAction func pickMedia(_ sender: Any) {
            presentPicker(.photoLibrary)
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
}
