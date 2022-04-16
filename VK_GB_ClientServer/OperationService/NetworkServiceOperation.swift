//
//  NetworkServiceOperation.swift
//  VK_GB_ClientServer
//
//  Created by Polina Tikhomirova on 15.04.2022.
//

import Foundation
import RealmSwift

class NetworkServiceOperation: AsyncOperation {
    var networkService = NetworkService<User>()
    var data: [User]?
    
    override func main() {
        DispatchQueue.global().async {
            self.networkService.fetch(type: .friends) { [weak self] result in
                switch result {
                case .failure(let error): print(error)
                case .success(let data):
                    self?.data = data.compactMap { $0 }
                    self?.state = .finished
                }
            }
        }
    }
}
