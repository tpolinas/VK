//
//  FriendsFactory.swift
//  VK_GB_ClientServer
//
//  Created by Polina Tikhomirova on 29.05.2022.
//

import Foundation
import UIKit

extension FriendsVC {
    func setupCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FriendCell.self,
            forIndexPath: indexPath)
        else { return UITableViewCell() }
        let letterKey = friendsSectionTitles[indexPath.section]
           if let friendsOnLetterKey = friendsFilteredDictionary[letterKey] {
               let myFriend = friendsOnLetterKey[indexPath.row]

               cell.configure(
                   name: myFriend.fullName,
                   url: myFriend.photo)
           }
        return cell
    }
}
