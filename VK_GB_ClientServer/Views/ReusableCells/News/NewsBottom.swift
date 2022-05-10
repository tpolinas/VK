//
//  NewsBottom.swift
//  VK_GB_ClientServer
//
//  Created by Polina Tikhomirova on 30.03.2022.
//

import UIKit

class NewsBottom: UITableViewCell {
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    func configure(
        isLiked: Bool,
        likesCounter: Int,
        commentsCounter: Int,
        sharedCounter: Int
    ) {
        if isLiked {
            likeButton.setImage(
                UIImage(systemName: "hand.thumbsup.fill"),
                for: .normal)
            likeButton.setTitle(
                "\(likesCounter)",
                for: .normal)
            likeButton.tintColor = .systemBlue
        } else {
            likeButton.setImage(
                UIImage(systemName: "hand.thumbsup"),
                for: .normal)
            likeButton.setTitle(
                "\(likesCounter)",
                for: .normal)
            likeButton.tintColor = .systemBlue
        }
        
        commentsButton.setTitle(
            "\(commentsCounter)",
            for: .normal)
        shareButton.setTitle(
            "\(sharedCounter)",
            for: .normal)
    }
}
