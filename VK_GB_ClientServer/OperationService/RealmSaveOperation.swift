//
//  RealmSaveOperation.swift
//  VK_GB_ClientServer
//
//  Created by Polina Tikhomirova on 15.04.2022.
//

import Foundation
import RealmSwift

final class RealmSaveOperation: AsyncOperation {
    private(set) var data: [UserRealm] = []
    private(set) var results: Results<UserRealm>?
    
    override init() {}
    
    override func main() {
        guard
            let fetchDataOperation = dependencies.first(
                where: { $0 is NetworkServiceOperation }) as? NetworkServiceOperation,
            let data = fetchDataOperation.data
        else {
            print("data is not loaded")
            return
        }
        self.data = data.map { UserRealm(user: $0) }
        DispatchQueue.main.async {
            do {
                try RealmService.save(items: self.data)
                self.state = .finished
            } catch {
                print("data is not loaded", error)
            }
        }
    }
}
