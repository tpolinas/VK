//
//  PhotoModel.swift
//  VK_GB_ClientServer
//
//  Created by Polina Tikhomirova on 26.02.2022.
//

import Foundation

struct Photos {
    public let sizes: [Photo]
    public let ownerID: Int
}

extension Photos: Codable {
    public enum CodingKeys: String, CodingKey {
        case sizes
        case ownerID = "owner_id"
    }
}

struct Photo {
    public let url: String
    
    init(url: String) {
        self.url = url
    }
}

extension Photo: Codable {
    public enum CodingKeys: String, CodingKey {
        case url
    }
}

struct Attachment: Decodable {
    public let type: String
    public let photo: Photos?
}
