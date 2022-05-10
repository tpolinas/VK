//
//  GroupsPromiseKit.swift
//  VK_GB_ClientServer
//
//  Created by Polina Tikhomirova on 16.04.2022.
//

import Foundation
import RealmSwift
import PromiseKit

final class GroupsPromiseKit {
    static let instance = GroupsPromiseKit()
    private init() {}
    
    private enum AppError: Error {
        case errorTask
        case failedToDecode
        case realmInOutFail
    }
    
    private lazy var urlSession = URLSession.shared
    private let scheme = "https"
    private let host = "api.vk.com"
    
    private var urlConstructor: URLComponents = {
        var constructor = URLComponents()
        constructor.scheme = "https"
        constructor.host = "api.vk.com"
        constructor.path = "/method/groups.get"
        
        constructor.queryItems = [
            URLQueryItem(
                name: "user_id",
                value: "\(Singleton.instance.userID)"),
            URLQueryItem(
                name: "extended",
                value: "1"),
            URLQueryItem(
                name: "access_token",
                value: "\(Singleton.instance.token)"),
            URLQueryItem(
                name: "v",
                value: "5.131"),
        ]
        return constructor
    }()
    
    public func fetchGroups() -> Promise<Data> {
        return Promise { resolver in
            guard let url = urlConstructor.url else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            self.urlSession.dataTask(with: request) { (data, response, error) in
                guard
                    error == nil,
                    let data = data
                else {
                    resolver.reject(AppError.errorTask)
                    return
                }
                resolver.fulfill(data)
            }.resume()
        }
    }
    
    public func decodeGroups(data: Data) -> Promise<[Group]> {
        return Promise { resolver in
            do {
                let json = try JSONDecoder().decode(
                    Response<Group>.self,
                    from: data)
                    .response.items
                resolver.fulfill(json)
            } catch {
                resolver.reject(AppError.failedToDecode)
            }
        }
    }

    public func groupsRealmService(groups: [Group]) -> Promise<[GroupRealm]> {
        return Promise { resolver in
            let items = groups.map { i in
                GroupRealm(group: i)
            }
            DispatchQueue.main.async {
                do {
                    try RealmService.save(items: items)
                    let group: [GroupRealm] = try RealmService.load(typeOf: GroupRealm.self)
                    resolver.fulfill(group)
                } catch {
                    resolver.reject(AppError.realmInOutFail)
                    print(error)
                }
            }
        }
    }
}
