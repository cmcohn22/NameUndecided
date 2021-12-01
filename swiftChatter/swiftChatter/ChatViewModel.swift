//
//  ChatViewModel.swift
//  swiftChatter
//
//  Created by Griffin Kaufman on 12/1/21.
//  Copyright © 2021 The Regents of the University of Michigan. All rights reserved.
//

import Foundation

final class ChatViewModel {
    
    var arrUsers: KxSwift<[User]> = KxSwift<[User]>([])
    
    func fetchParticipantList(_ name: String) { // replace w get request
        
        SocketHelper.shared.participantList {[weak self] (result: [User]?) in
            
            guard let self = self,
                let users = result else{
                    return
            }
            
            var filterUsers: [User] = users
            
            // Removed login user from list
            if let index = filterUsers.firstIndex(where: {$0.nickname == name}) {
                filterUsers.remove(at: index)
            }
            
            self.arrUsers.value = filterUsers
        }
    }
}
