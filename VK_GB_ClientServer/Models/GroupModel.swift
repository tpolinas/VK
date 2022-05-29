//
//  GroupModel.swift
//  VK_GB_ClientServer
//
//  Created by Polina Tikhomirova on 26.02.2022.
//

import Foundation

struct Group {
    public let id: Int
    public let name: String
    public let avatar: String
}

extension Group: Codable {
    public enum CodingKeys: String, CodingKey {
        case id
        case name
        case avatar = "photo_100"
    }
}

extension Group: Equatable {
    public static func == (lhs: Group, rhs: Group) -> Bool {
        return lhs.name == rhs.name
    }
}

