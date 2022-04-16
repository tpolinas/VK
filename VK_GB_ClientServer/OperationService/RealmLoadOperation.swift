//
//  RealmLoadOperation.swift
//  VK_GB_ClientServer
//
//  Created by Polina Tikhomirova on 15.04.2022.
//

import Foundation
import RealmSwift

final class RealmLoadOperation: AsyncOperation {
    var friends = [UserRealm]()
    
    override func main() {
        guard let data = dependencies.first as? RealmSaveOperation?,
              data?.data != nil else {
                  print("dependencies error")
                  return
              }
        DispatchQueue.main.async {
            do {
                self.friends = try RealmService.load(typeOf: UserRealm.self)
                self.state = .finished
            } catch {
                print("can't load data", error)
            }
        }
    }
}
