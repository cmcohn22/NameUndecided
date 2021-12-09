//
//  CreateMnkyChat.swift
//  swiftChatter
//
//  Created by sugih on 7/24/20.
//  Copyright © 2020 The Regents of the University of Michigan. All rights reserved.
//
import UIKit
import CoreLocation

final class CreateMnkyChat: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate, CLLocationManagerDelegate {

    lazy var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        chattname.delegate = self
        chattdescription.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        chattname.resignFirstResponder()
        chattdescription.resignFirstResponder()
        return true
    }

    
    var radiusIn: Double!
    @IBOutlet weak var chattname: UITextField!
    @IBOutlet weak var chattdescription: UITextField!
    @IBOutlet weak var slideValue: UILabel!
    @IBAction func sliderValue(_ sender: UISlider) {
        slideValue.text = String(sender.value)
        radiusIn = Double(sender.value)
    }
    
    @IBAction func submitNewChatt(_ sender: Any) {
        let currentlocation = locationManager.location
        let chatt = Chatt(name: self.chattname.text,
                          description: self.chattdescription.text,
                          lat: currentlocation?.coordinate.latitude,
                          long: currentlocation?.coordinate.longitude,
                          radius: radiusIn)
        print("AHHH AHHH MNKY AHHHHH")
        print(currentlocation?.coordinate.latitude)
        print(currentlocation?.coordinate.longitude)
        print(chatt.lat as Any)
        print(chatt.long as Any)
        print(chatt.radius as Any)

        ChattStore.shared.createChatt(chatt, image: postImage.image)
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
    
}
