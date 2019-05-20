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
    private var selectedViews = [UIView]()
    private var permenantlySelectedViews = [UIView]()
    
    // MARK: Setup
    func set(text: String) {
        textLabel.text = text
    }
    
    func select(orientation: WordOrientation, startOfSelection: Bool, endOfSelection: Bool)  {
        let view = UIView()
        view.backgroundColor = .yellow
        self.insertSubview(view, at: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        switch orientation {
        case .Vertical(let option):
            if startOfSelection || endOfSelection {
                switch option {
                case .TopToBottom:
                    return
                case .BottomToTop:
                    return
                }
            } else {
                view.topAnchor.constraint(equalTo: textLabel.topAnchor).isActive = true
                view.bottomAnchor.constraint(equalTo: textLabel.bottomAnchor).isActive = true
                view.widthAnchor.constraint(equalToConstant: self.bounds.width * 2/3).isActive = true
            }
        case .Horizontal(let option):
            if startOfSelection || endOfSelection {
                switch option {
                case .LeftToRight:
                    return
                case .RightToLeft:
                    return
                }
            } else {
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
                view.heightAnchor.constraint(equalToConstant: self.bounds.height * 2/3).isActive = true
            }
        case .diagonal(let vOption, let hOption):
            if startOfSelection || endOfSelection {

            } else {
                view.heightAnchor.constraint(equalToConstant: self.bounds.height * 1.5).isActive = true
                view.widthAnchor.constraint(equalToConstant: self.bounds.width * 2/3).isActive = true
                var direction: CGFloat = 1
                if (hOption == .LeftToRight && vOption == .BottomToTop) {
                    direction = 1
                } else if (hOption == .LeftToRight && vOption == .TopToBottom) {
                    direction = -1
                } else if (hOption == .RightToLeft && vOption == .BottomToTop) {
                    direction = -1
                } else if (hOption == .RightToLeft && vOption == .TopToBottom) {
                    direction = 1
                }
                view.transform = CGAffineTransform(rotationAngle: direction * CGFloat.pi / 4)
            }
        }
        selectedViews.append(view)
    }
    
    func selectPermenantly() {
        selectedViews.forEach({
            $0.backgroundColor = .green
            permenantlySelectedViews.append($0)
        })
        selectedViews.removeAll()
    }
    
    func deselect(){
        selectedViews.forEach({ $0.removeFromSuperview() })
        selectedViews.removeAll()
    }

}


// MARK: UINib Extension
extension UINib {
    static let GridCell = UINib(nibName: "GridCell", bundle: nil)
}
