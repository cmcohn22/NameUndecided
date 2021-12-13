//
//  ChatUsersVC.swift
//  swiftChatter
//
//  Created by Griffin Kaufman on 12/8/21.
//  Copyright © 2021 The Regents of the University of Michigan. All rights reserved.
//

import UIKit


final class ChatUsersTableCell: UITableViewCell {

    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var adminLabel: UILabel!
    @IBOutlet weak var userPic: UIImageView!
    
}

//protocol MuteChatDelegate{
//    func muteChat(mute: Bool)
//}

final class ChatUsersVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    static let shared = ChatUsersVC()
    
    var chat_ident: String!
    var isAdmin: Bool = false
    
//    var delegate: MuteChatDelegate?
    
    @IBOutlet weak var MnkyChatName: UILabel!
    @IBOutlet weak var camera: UIButton!
    @IBOutlet weak var photo: UIButton!
    @IBOutlet weak var submitImage: UIButton!
    @IBOutlet weak var MnkyChatDescription: UILabel!
    @IBOutlet weak var chatImage: UIImageView!
    @IBAction func leaveChat(_ sender: Any) {
        ChatSettings.shared.leave_chat(chat_ident: chat_ident)
    }
    @IBAction func toggleMute(_ sender: Any) {
        if((sender as AnyObject).isOn == true){
//            delegate?.muteChat(mute: true)
            mutedChat = true
        }
        else{
//            delegate?.muteChat(mute: false)
            mutedChat = false
        }

    }
    
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
    @IBAction func changeChatImage(_ sender: Any) {
        if isAdmin{
            ChatSettings.shared.changeChatImg(chat_id: chat_ident, imageIn: chatImage.image)
        }
    }
    
    func isUserAdmin(){
        for user in ChatSettings.shared.chatUsers{
            if user.isAdmin && user.username == UserStore.shared.activeUser.username{
                isAdmin = true
            }
        }
    }
        
    func presentPicker(_ sourceType: UIImagePickerController.SourceType) {
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
                    chatImage.image = (info[UIImagePickerController.InfoKey.editedImage] as? UIImage ??
                                        info[UIImagePickerController.InfoKey.originalImage] as? UIImage)?
                        .resizeImage(targetSize: CGSize(width: 265, height: 174))
                }
            }
            picker.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup refreshControler here later
        // iOS 14 or newer
        refreshControl?.addAction(UIAction(handler: refreshTimeline), for: UIControl.Event.valueChanged)
        refreshTimeline(nil)
    }

    /*
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshTimeline()
    }*/
    
    // MARK:-
    private func refreshTimeline(_ sender: UIAction?) {
        self.tableView.reloadData()
        ChatSettings.shared.get_chat_info(chat_id: chat_ident!) { success in
                DispatchQueue.main.async {
                    if success {
                        self.tableView.reloadData()
                        self.MnkyChatName.text = ChatSettings.shared.chat_name
                        self.MnkyChatDescription.text = ChatSettings.shared.chat_description
                        let imageUrl: URL = URL(string: (ChatSettings.shared.image)!)!
                        DispatchQueue.global(qos: .userInitiated).async {
                                 
                                let chattPicData:NSData = NSData(contentsOf: imageUrl)!
                                
                                 
                                 // When from background thread, UI needs to be updated on main_queue
                                DispatchQueue.main.async {
                                     let proImage = UIImage(data: chattPicData as Data)
                                    self.chatImage.image = proImage?.resizeImage(targetSize: CGSize(width: self.chatImage.frame.size.width, height: self.chatImage.frame.size.height))
                                 }
                             }
                        self.isUserAdmin()
                        if(self.isAdmin == false){
                            self.submitImage.isHidden = true
                            self.photo.isHidden = true
                            self.camera.isHidden = true
                        }
                    }
                    // stop the refreshing animation upon completion:
                    self.refreshControl?.endRefreshing()
                }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // how many sections are in table
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // how many rows per section
        return ChatSettings.shared.chatUsers.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // event handler when a cell is tapped

        //selectedRow = indexPath.row
        //chatt = chatts[indexPath.row]
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // populate a single cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatUsersTableCell", for: indexPath) as? ChatUsersTableCell else {
            fatalError("No reusable cell!")
        }

        let chatUser = ChatSettings.shared.chatUsers[indexPath.row]
        cell.backgroundColor = (indexPath.row % 2 == 0) ? .systemGray5 : .systemGray6
        cell.fullnameLabel.text = "\(chatUser.first_name!) \(chatUser.last_name!)"
        if(chatUser.isAdmin) {
            cell.adminLabel.text = "Admin"
        }
        else {
            cell.adminLabel.text = ""
        }
        let imageUrl: URL = URL(string: (chatUser.profile_pic)!)!
        DispatchQueue.global(qos: .userInitiated).async {
                 
                let chattPicData:NSData = NSData(contentsOf: imageUrl)!
                
                 
                 // When from background thread, UI needs to be updated on main_queue
                DispatchQueue.main.async {
                     let proImage = UIImage(data: chattPicData as Data)
                    cell.userPic.image = proImage?.resizeImage(targetSize: CGSize(width: cell.userPic.frame.size.width, height: cell.userPic.frame.size.height))
                 }
             }
        return cell
    }
    
    
    
}

