//
//  UserModel.swift
//  VK_GB_ClientServer
//
//  Created by Polina Tikhomirova on 26.02.2022.
//

import Foundation

struct User {
    public let id: Int
    public let firstName: String
    public let lastName: String
    public let photo: String
    public let largePhoto: String
    public let sex: Int
    public var fullName: String { lastName + " " + firstName }
}

extension User: Codable {
    public enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case photo = "photo_50"
        case largePhoto = "photo_200"
        case sex
    }
}

extension User: Comparable {
    public static func < (lhs: User, rhs: User) -> Bool {
        lhs.lastName < rhs.lastName
    }
}
