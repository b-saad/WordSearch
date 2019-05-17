//
//  GridCell.swift
//  WordSearch
//
//  Created by Bilal Saad on 2019-05-16.
//  Copyright © 2019 Bilal Saad. All rights reserved.
//

import UIKit

final class GridCell: UICollectionViewCell {
    
    // MARK: IBOutlets
    @IBOutlet private var textLabel: UILabel!
    
    // MARK: Properties
    private var permenantlySelected: Bool = false {
        didSet {
            if permenantlySelected {
                self.backgroundColor = .green
            } else {
                self.backgroundColor = .white
            }
        }
    }
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.backgroundColor = .yellow
            } else {
                self.backgroundColor = permenantlySelected ? .green : .white
            }
        }
    }
    
    // MARK: Setup
    func set(text: String) {
        textLabel.text = text
    }
    
    func selectPermentantly() {
        self.permenantlySelected = true
    }

}

// MARK: UINib Extension
extension UINib {
    static let GridCell = UINib(nibName: "GridCell", bundle: nil)
}
