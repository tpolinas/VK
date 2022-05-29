//
//  NewsModel.swift
//  VK_GB_ClientServer
//
//  Created by Polina Tikhomirova on 30.03.2022.
//

import Foundation

struct News {
    public let sourceID: Int
    public let date: Date
    public var text: String?
    public let photosURLs: [Attachment]?
    public let likes: Likes
    public let reposts: Reposts
    public let comments: Comments
}

extension News: Decodable {
    public enum CodingKeys: String, CodingKey {
        case sourceID = "source_id"
        case date
        case text
        case photosURLs = "attachments"
        case comments
        case likes
        case reposts
    }
}

extension News: Comparable {
    public static func < (lhs: News, rhs: News) -> Bool {
        lhs.date < rhs.date
    }
}

extension News: Equatable {
    public static func == (lhs: News, rhs: News) -> Bool {
        lhs.date == rhs.date &&
        lhs.sourceID == rhs.sourceID
    }
}


// MARK: - Comments

struct Comments: Codable {
    public let count: Int

    public enum CodingKeys: String, CodingKey {
        case count
    }
}

struct Likes: Codable {
    public let count: Int

    public enum CodingKeys: String, CodingKey {
        case count
    }
}

// MARK: - Reposts

struct Reposts: Codable {
    public let count: Int

    public enum CodingKeys: String, CodingKey {
        case count
    }
}
