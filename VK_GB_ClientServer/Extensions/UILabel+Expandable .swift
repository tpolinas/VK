//
//  UILabel+Expandable .swift
//  VK_GB_ClientServer
//
//  Created by Polina Tikhomirova on 03.05.2022.
//

import UIKit

public protocol ExpandableLabelDelegate {
    func didPressButton(at indexPath: IndexPath)
}

public extension UILabel {
    var isTruncated: Bool {
        guard let labelText = text else {
            return false
        }
        let labelTextSize = (labelText as NSString)
            .boundingRect(
                with: CGSize(
                    width: frame.size.width,
                    height: .greatestFiniteMagnitude),
                options: .usesLineFragmentOrigin,
                attributes: [.font: font ?? UIFont()],
                context: nil)
            .size

        return labelTextSize.height > bounds.size.height
    }
}
