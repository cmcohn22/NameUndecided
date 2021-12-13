//
//  MessageVC.swift
//  swiftChatter
//
//  Created by Griffin Kaufman on 12/2/21.
//  Copyright © 2021 The Regents of the University of Michigan. All rights reserved.
//

import UIKit
import Starscream
import CoreLocation
import MobileCoreServices
import UniformTypeIdentifiers
import Alamofire

struct MessageSocket: Encodable{
    let lat:Double
    let long:Double
    let type:String
    let chat_id:String
    let content:String
    
    init(contents: String, chatID: String, lat: Double, long: Double, type: String){// pass params like a constructor
        self.lat = lat
        self.long = long
        self.type = type
        self.chat_id = chatID
        self.content = contents
    }
}

final class MessageVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate {
    
    @IBAction func settings(_ sender: Any) {
        print("-------hello--------")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChatUsersVC") as! ChatUsersVC
            self.present(nextViewController, animated:true, completion:nil)
    }
    
    lazy var locationManager = CLLocationManager()
   
    @IBOutlet weak var MessageContent: UITextField!
    
    var chat_id : String!
    var chat_lat: Double!
    var chat_long: Double!
    var chat_name: String!
    var pdfData: Data!
    var pdfPicked: Bool! = false
    var imagePicked: Bool! = false
    var socket: WebSocket!
    var isConnected = false
    let server = WebSocketServer()
        
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)

        refreshControl?.addAction(UIAction(handler: refreshTimeline), for: UIControl.Event.valueChanged)
        self.title = chat_name
        
        refreshTimeline(nil)
        
        
    }
    @objc func loadList(notification: NSNotification){
        if let dict = notification.userInfo as NSDictionary? {
                   if let mex = dict["message"] as? Message{
                       MessageLog.shared.appendfunc(chatid: chat_id, mezzo: mex)
                       DispatchQueue.main.async {
                               self.tableView.reloadData()
                           // stop the refreshing animation upon completion:
                           self.refreshControl?.endRefreshing()
                       }

                   }
               }
    
    }


    @IBAction func SendMessage(_ sender: Any) {
        if UserStore.shared.activeUser.tokenId == nil {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "StartUp") as! StartUpVC
                self.present(nextViewController, animated:true, completion:nil)
            return
        }
        
        
        guard let currentlocation = locationManager.location else{
                   return
               }
        let dblLat = currentlocation.coordinate.latitude
        let dblLong = currentlocation.coordinate.longitude
        print(imagePicked)
        print(pdfPicked)
        if (imagePicked == true) {
            UploadImageStore.shared.uploadImage(image: postImage.image, chat_id, chat_lat, chat_long)
            postImage.image = nil
            print("hit3")
 
        }
        if(pdfPicked == true){
            UploadImageStore.shared.uploadDocument(pdfData: self.pdfData, chat_id, chat_lat, chat_long)
            print("hit2")
        }
        if(pdfPicked == false && imagePicked == false){
            let jsonObject = MessageSocket.init(contents: MessageContent.text!, chatID: chat_id, lat:dblLat, long: dblLong, type: "chat_message")
                    let jsonEncoder = JSONEncoder()
                            let jsonData = try! jsonEncoder.encode(jsonObject)
                            let json = String(data: jsonData, encoding: .utf8)!
            StartUpVC.shared.writeText((Any).self, json: json)
            print("hit1")
        }
        MessageContent.text = ""
        pdfPicked = false
        imagePicked = false
        
    }
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if(segue.identifier == "SpecificChatSegue"){
            //TODO
        }
        if let secondVC = segue.destination as? ChatUsersVC,
           let chatDex = tableView.indexPathForSelectedRow?.row
        {
            secondVC.chat_id =  ActiveChats.shared.chatts[chatDex].chat_id
            secondVC.chat_name =  ActiveChats.shared.chatts[chatDex].name
            secondVC.chat_description =  ActiveChats.shared.chatts[chatDex].description
        }
    }

    // MARK:-
    private func refreshTimeline(_ sender: UIAction?) {
        guard let currentlocation = locationManager.location else{
                   return
               }
        let dblLat = currentlocation.coordinate.latitude
        let dblLong = currentlocation.coordinate.longitude
        //Universal Token So People Can See Messages
        var toke = "Token a23cb7a7efd4981c4a85a0cd6428213b38489c01"
        if UserStore.shared.activeUser.tokenId != nil{
            toke = "Token \(UserStore.shared.activeUser.tokenId!)"
        }
        MessageLog.shared.get_messages(token: toke, chat_id: chat_id, lat: dblLat, long: dblLong){ success in
            DispatchQueue.main.async {
                if success {
                    self.tableView.reloadData()
                }
                // stop the refreshing animation upon completion:
                self.refreshControl?.endRefreshing()
            }
        }
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
                imagePicked = true
        }
    
    @IBAction func pickDocument(_ sender: Any) {
        //Call Delegate
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeText),String(kUTTypeContent),String(kUTTypeItem),String(kUTTypeData)], in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        pdfPicked = true
        print("import result : \(myURL)")
        let data = NSData(contentsOf: myURL)
        do{
                   
            self.pdfData = try Data(contentsOf: myURL)
            self.MessageContent.text = myURL.lastPathComponent
                    
                    //uploadActionDocument(documentURLs: myURL, pdfName: myURL.lastPathComponent)
        }catch{
                    print(error)
        }
    }
    
    
    // MARK:- TableView handlers
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // how many sections are in table
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // how many rows per section
        return MessageLog.shared.messages.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // event handler when a cell is tapped
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 152
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = socketInfo.shared.messagesDict[self.chat_id]?[indexPath.row]
        
        var retCell: UITableViewCell
                
        if (message?.type == "chat_message") || (message?.type == "message"){
            // populate a single cell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableCell", for: indexPath) as? MessageTableCell else {
                print("Interesting")
                fatalError("No reusable cell!")
            }
            
            cell.backgroundColor = (indexPath.row % 2 == 0) ? .systemGray5 : .systemGray6
            cell.firstnameLabel.text = message?.first_name
            cell.lastnameLabel.text = message?.last_name
            cell.contentLabel.text = message?.content
            
            let imageUrl: URL = URL(string: (message?.profile_pic)!)!
            
            DispatchQueue.global(qos: .userInitiated).async {
                     
                     let imageData:NSData = NSData(contentsOf: imageUrl)!
                    
                     
                     // When from background thread, UI needs to be updated on main_queue
                    DispatchQueue.main.async {
                         let image = UIImage(data: imageData as Data)
                        let width = cell.profilePic.frame.size.width
                        let height = cell.profilePic.frame.size.height
                        let size = CGSize(width: width, height: height)
                        cell.profilePic.image = image?.resizeImage(targetSize: size)
                     }
                 }
            
            retCell = cell
        }
        else{
            guard let cellPicture = tableView.dequeueReusableCell(withIdentifier: "MessageTableCellPicture", for: indexPath) as? MessageTableCellPicture else {
                print("Interesting")
                fatalError("No reusable cell!")
            }
            cellPicture.backgroundColor = (indexPath.row % 2 == 0) ? .systemGray5 : .systemGray6
            cellPicture.first_name.text = message?.first_name
            cellPicture.last_name.text = message?.last_name
            
            let isPDf: Bool! = (message?.content?.suffix(10) == "messagePDF")
            
            let profilePicUrl: URL = URL(string: (message?.profile_pic)!)!
            let contentUrl: URL = URL(string: (message?.content)!)!

            if(isPDf){
                let linkString: String! = message?.content
                let showString: String = String(describing: message?.first_name) + "'s PDF"
                let attributedString = NSMutableAttributedString(string: showString)
                attributedString.addAttribute(.link, value: linkString, range: NSMakeRange(0, showString.count))
                cellPicture.pdfFile.attributedText = attributedString
            }
            
            DispatchQueue.global(qos: .userInitiated).async {
                     
                    let proPicData:NSData = NSData(contentsOf: profilePicUrl)!
                    let conPicData:NSData = NSData(contentsOf: contentUrl)!
                    
                     
                     // When from background thread, UI needs to be updated on main_queue
                    DispatchQueue.main.async {
                         let proImage = UIImage(data: proPicData as Data)
                        cellPicture.profilePic.image = proImage?.resizeImage(targetSize: CGSize(width: cellPicture.profilePic.frame.size.width, height: cellPicture.profilePic.frame.size.height))
                        if(isPDf == false){
                            let conImage = UIImage(data: conPicData as Data)
                            cellPicture.content.image = conImage?.resizeImage(targetSize: CGSize(width: cellPicture.content.frame.size.width, height: cellPicture.content.frame.size.height))
                            cellPicture.pdfFile.isHidden = true
                        }
                     }
                 }
            retCell = cellPicture
        }
        
        return retCell
    }
}
