//
//  NewsTextCell.swift
//  VK_GB_ClientServer
//
//  Created by Polina Tikhomirova on 30.03.2022.
//

import UIKit

class NewsTextCell: UITableViewCell {

    @IBOutlet var newsText: UILabel!
    
    var indexPath = IndexPath()
    var delegate: ExpandableLabelDelegate?
    var textIsTruncated = Bool()
    
    override func setSelected(
        _ selected: Bool,
        animated: Bool
    ) {
       let tapGesture = UITapGestureRecognizer(
        target: self,
        action: #selector(buttonTouched))
        
       newsText.addGestureRecognizer(tapGesture)
    }

   @objc func buttonTouched() {
       delegate?.didPressButton(at: indexPath)
   }

    func configure(
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
