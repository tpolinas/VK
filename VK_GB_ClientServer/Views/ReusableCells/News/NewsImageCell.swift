//
//  NewsImageCellCollectionViewCell.swift
//  VK_GB_ClientServer
//
//  Created by Polina Tikhomirova on 30.03.2022.
//

import UIKit
import Kingfisher

class NewsImageCell: UICollectionViewCell,
                     UIGestureRecognizerDelegate {

    @IBOutlet var newsImage: UIImageView!
    
    func configure(image: UIImage?) {
        self.newsImage.isHidden = true
        self.newsImage.image = nil
        self.newsImage?.image = image
        self.newsImage.contentMode = .scaleAspectFit
        self.newsImage.isHidden = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        newsImage.image = nil
    }
}
