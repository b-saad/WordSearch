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
    
    // MARK: Properties
    private var gridCollectionViewController: GridCollectionViewController?
    private var wordListCollectionViewController: WordListCollectionViewController?
    private let words = [
        "Swift",
        "Kotlin",
        "ObjectiveC",
        "Variable",
        "Java",
        "Mobile"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        wordListCollectionViewController = WordListCollectionViewController(collectionView: wordListCollectionView, words: words)
        gridCollectionViewController = GridCollectionViewController(collectionView: gridCollectionView, words: words)
        if let wordListCVC = wordListCollectionViewController {
            gridCollectionViewController?.delegate = wordListCVC
        }
    }

}

