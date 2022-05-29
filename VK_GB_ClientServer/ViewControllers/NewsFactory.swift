//
//  NewsFactory.swift
//  VK_GB_ClientServer
//
//  Created by Polina Tikhomirova on 27.05.2022.
//

import Foundation
import UIKit

extension NewsVC {
    func setupCell(indexPath: IndexPath) -> UITableViewCell {
        let news = userNews[indexPath.section]
        switch indexPath.row {
        case 0:
            indexOfCell = .top
        case 1:
            indexOfCell = (news.text == nil) ? .image : .text
        case 2:
            indexOfCell = (news.photosURLs == nil) || news.text == nil
            ? .bottom : .image
        case 3:
            indexOfCell = .bottom
        default:
            indexOfCell = .none
        }
        
        switch indexOfCell {
        case .top:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NewsTopCell.self,
                forIndexPath: indexPath)
            else { return UITableViewCell() }
            let group = loadGroupByID(news.sourceID)
            guard
                group?.avatar != nil
            else { return UITableViewCell() }
            
            cell.configure(
                avatar: group!.avatar,
                name: group!.name,
                newsTime: news.date.toString(
                                    dateFormat: .dateTime))
            
            return cell
        case .text:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NewsTextCell.self,
                forIndexPath: indexPath)
            else { return UITableViewCell() }
            
            guard
                let textIsTruncated = textCellState[indexPath]
            else { return cell }
            
            cell.configure(
                text: news.text ?? "",
                indexPath: indexPath,
                textIsTruncated: textIsTruncated)
            
            cell.delegate = self
            cell.selectionStyle = .none
            
            return cell
        case .image:
            var photos = [String]()
            news.photosURLs?.forEach({ index in
                guard let photoURL = index.photo?.sizes.last?.url else { return }
                
                photos.append(photoURL)
            })
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NewsImagesCollection.self,
                forIndexPath: indexPath)
            else { return UITableViewCell() }
            
            cell.currentNews = nil
            cell.photoURLs = []
            
            cell.currentNews = news
            cell.photoURLs = photos

            return cell
        case .bottom:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NewsBottom.self,
                forIndexPath: indexPath)
            else { return UITableViewCell() }

            cell.configure(
                isLiked: false,
                likesCounter: news.likes.count,
                commentsCounter: news.comments.count,
                sharedCounter: news.reposts.count)

            return cell
        case .none:
            return UITableViewCell()
        }
    }
}

extension NewsVC {
    func setupHeightForRowAt(indexPath: IndexPath) -> CGFloat {
        if indexPath.row == Identifier.text.rawValue {
            if userNews[indexPath.section].text == "" {
                return 0
            }
        }
        if indexPath.row == Identifier.image.rawValue {
            guard
                let height = NewsImagesCollection.collectionHeight[indexPath]
            else {
                return UITableView.automaticDimension
                
            }
            return height
        }
        return UITableView.automaticDimension
    }
}

extension NewsVC {
    func setupNumberOfRowsInSection(section: Int) -> Int {
        var number = newsCellCount
        if userNews[section].text == nil { number -= 1 }
        if userNews[section].photosURLs == nil { number -= 1 }
        return number
    }
}
