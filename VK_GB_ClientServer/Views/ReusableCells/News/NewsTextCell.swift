//
//  NewsTextCell.swift
//  VK_GB_ClientServer
//
//  Created by Polina Tikhomirova on 30.03.2022.
//

import UIKit

class NewsTextCell: UITableViewCell {
    @IBOutlet weak var newsText: UILabel!
    
    private var indexPath = IndexPath()
    private var textIsTruncated = Bool()
    public var delegate: ExpandableLabelDelegate?
    
    override func setSelected(
        _ selected: Bool,
        animated: Bool
    ) {
       let tapGesture = UITapGestureRecognizer(
        target: self,
        action: #selector(buttonTouched))
        
       newsText.addGestureRecognizer(tapGesture)
    }

   @objc private func buttonTouched() {
       delegate?.didPressButton(at: indexPath)
   }

    public func configure(
        text: String,
        indexPath: IndexPath,
        textIsTruncated: Bool
   ) {
       self.newsText.text = text
       self.indexPath = indexPath
       self.textIsTruncated = newsText.isTruncated
       
       if textIsTruncated {
           newsText.numberOfLines = 4
           newsText.lineBreakMode = .byTruncatingTail
       } else {
           newsText.numberOfLines = 0
           newsText.lineBreakMode = .byWordWrapping
       }
   }
}
