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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        chattname.delegate = self
        chattdescription.delegate = self
    }
    
    var locationManager = CLLocationManager()
    var userLocation: CLLocation!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        determineMyCurrentLocation()
    }
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }


    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        chattname.resignFirstResponder()
        chattdescription.resignFirstResponder()
        return true
    }
        
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            userLocation = locations[0] as CLLocation
            
            // Call stopUpdatingLocation() to stop listening for location updates,
            // other wise this function will be called every time when user location changes.
            
           // manager.stopUpdatingLocation()
            
            print("user latitude = \(userLocation.coordinate.latitude)")
            print("user longitude = \(userLocation.coordinate.longitude)")
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
        {
            print("Error \(error)")
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
