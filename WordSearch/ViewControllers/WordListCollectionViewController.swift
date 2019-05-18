//
//  WordListCollectionViewController.swift
//  WordSearch
//
//  Created by Bilal Saad on 2019-05-17.
//  Copyright © 2019 Bilal Saad. All rights reserved.
//

import UIKit

final class WordListCollectionViewController: NSObject {
    
    // MARK: Properties
    private let collectionView: UICollectionView
    private var data = [String]()
    
    // MARK: Initialization
    init(collectionView: UICollectionView, words: [String]) {
        self.collectionView = collectionView
        self.data = words.map({$0.uppercased()})
        super.init()

        collectionView.register(.WordCell, forCellWithReuseIdentifier: String(describing: WordCell.self))
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

// MARK - UICollectionViewDataSource
extension WordListCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WordCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.set(text: data[indexPath.row])
        return cell
    }
    
}

// MARK - UICollectionViewDelegate
extension WordListCollectionViewController: UICollectionViewDelegate {}

// MARK - UICollectionViewDelegateFlowLayout
extension WordListCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height / 4
        let width = collectionView.frame.width / 3
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK - GridCollectionViewControllerDelegate
extension WordListCollectionViewController: GridCollectionViewControllerDelegate {
    func wordFound(word: String) {
        guard let indexOfWordFound = data.firstIndex(of: word) else { return }
        let indexPath = IndexPath(row: indexOfWordFound, section: 0)
        if let wordCell = collectionView.cellForItem(at: indexPath) as? WordCell {
            wordCell.strikeThroughText()
        }
    }
}
