//
//  ViewController.swift
//  WordSearch
//
//  Created by Bilal Saad on 2019-05-16.
//  Copyright © 2019 Bilal Saad. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet private var gridCollectionView: UICollectionView!
    @IBOutlet private var wordListCollectionView: UICollectionView!
    @IBOutlet private var wordListBackgroundView: UIView!
    @IBOutlet private var topLabel: UILabel!
    
    // MARK: Properties
    private var gridCollectionViewController: GridCollectionViewController?
    private var wordListCollectionViewController: WordListCollectionViewController?
    private let potentialWords = [
        "Swift",
        "Kotlin",
        "ObjectiveC",
        "Variable",
        "Java",
        "Mobile",
        "HTML",
        "CSS",
        "Shopify",
    ]
    private var wordsAdded = [String]()
    private var wordsFound = [String]() {
        didSet {
            setTopLabel()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        gridCollectionViewController = GridCollectionViewController(collectionView: gridCollectionView)
        wordListCollectionViewController = WordListCollectionViewController(collectionView: wordListCollectionView)
        if let wordListCVC = wordListCollectionViewController {
            gridCollectionViewController?.delegates.append(self)
            gridCollectionViewController?.delegates.append(wordListCVC)
        }
        createWordSearch()
        wordListBackgroundView.layer.cornerRadius = 8
        setTopLabel()
    }
    
    private func setTopLabel() {
        if wordsFound.count == wordsAdded.count {
            topLabel.text = "All words found"
        } else {
             topLabel.text = "Words found: \(wordsFound.count)"
        }
    }
    
    private func createWordSearch() {
        let wordSearchGenerator = WordSearchGenerator(numRows: 10, numColumns: 10, words: potentialWords)
        wordSearchGenerator.delegate = self
        let wordSearch = wordSearchGenerator.generateWordSearch()
        wordListCollectionViewController?.setData(words: wordsAdded)
        gridCollectionViewController?.setData(wordSearch: wordSearch, words: wordsAdded)
    }

}

// MARK - WordSearchGeneratorDelegate
extension MainViewController: WordSearchGeneratorDelegate {
    func wordSearchFilled(with words: [String]) {
        self.wordsAdded = words.map({$0.uppercased()})
    }
}

// MARK - GridCollectionViewControllerDelegate
extension MainViewController: GridCollectionViewControllerDelegate {
    func wordFound(word: String) {
        wordsFound.append(word)
    }
}
