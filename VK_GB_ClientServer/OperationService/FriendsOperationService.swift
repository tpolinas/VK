//
//  FriendsOperationService.swift
//  VK_GB_ClientServer
//
//  Created by Polina Tikhomirova on 15.04.2022.
//

import Foundation
import RealmSwift

final class FriendsOperationService {
    static let instance = FriendsOperationService()
    private init() {}
    
    var friends = [UserRealm]()
    
    func fetchFriends(completion: @escaping ([UserRealm]) -> Void) {
        let dataQueue: OperationQueue = {
            let queue = OperationQueue()
            queue.qualityOfService = .utility
            return queue
        }()
        
        let fetchData = NetworkServiceOperation()
        let saveRealm = RealmSaveOperation()
        let loadRealm = RealmLoadOperation()
        
        saveRealm.addDependency(fetchData)
        loadRealm.addDependency(saveRealm)
        loadRealm.completionBlock = {
            completion(loadRealm.friends)
        }
        
        dataQueue.addOperation(fetchData)
        dataQueue.addOperation(saveRealm)
        dataQueue.addOperation(loadRealm)
    }
}
