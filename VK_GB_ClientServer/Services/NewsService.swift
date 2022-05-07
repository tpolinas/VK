//
//  NewsService.swift
//  VK_GB_ClientServer
//
//  Created by Polina Tikhomirova on 03.05.2022.
//

import UIKit
import RealmSwift

final class NewsService {
    static let instance = NewsService()
    private init() {}
    
    let networkService = NetworkService<News>()
    var userNews = [News]()
    
    func getNews(
        nextFrom: String? = "",
        completion: @escaping () -> Void
    ) {
        networkServiceFunction(nextFrom: nextFrom) { news in
            self.userNews = []
            self.userNews = news
            completion()
        }
    }
    
    func networkServiceFunction(
        nextFrom: String? = "",
        completion: @escaping ([News]) -> Void
    ) {
        networkService.fetch(type: .feed) { [weak self] result in
            switch result {
            case .success(let myNews):
                myNews.forEach() { index in
                    guard let attachment = index.photosURLs else { return }
                    attachment.forEach { item in
                        guard item.type == "photo" else { return }
                        let new = News(
                            sourceID: index.sourceID,
                            date: index.date,
                            text: index.text ?? "",
                            photosURLs: attachment,
                            likes: index.likes,
                            reposts: index.reposts,
                            comments: index.comments)
                        guard !self!.userNews.contains(new) else { return }
                    self?.userNews.append(new)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
