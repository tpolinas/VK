//
//  GroupsFactory.swift
//  VK_GB_ClientServer
//
//  Created by Polina Tikhomirova on 29.05.2022.
//

import Foundation
import UIKit

extension GroupsVC {
    func setupCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: GroupCell.self,
            forIndexPath: indexPath)
        else { return UITableViewCell() }
            
        let myGroup = groupsFiltered[indexPath.row]

        cell.configure(
            name: myGroup.name,
            url: myGroup.avatar)
       
        return cell
    }
}


