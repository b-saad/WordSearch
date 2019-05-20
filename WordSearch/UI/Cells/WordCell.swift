//
//  WordCell.swift
//  WordSearch
//
//  Created by Bilal Saad on 2019-05-17.
//  Copyright © 2019 Bilal Saad. All rights reserved.
//

import UIKit

final class WordCell: UICollectionViewCell {
    
    // MARK: IBOutlets
    @IBOutlet private var textLabel: UILabel!
    
    // MARK: Setup
    func set(text: String) {
        textLabel.text = text
    }
    
    func strikeThroughText() {
        if let text = textLabel.text {
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length))
            textLabel.attributedText = attributedString
        }
    }
}

// MARK: UINib Extension
extension UINib {
    static let WordCell = UINib(nibName: "WordCell", bundle: nil)
}

