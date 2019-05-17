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
    @IBOutlet private var collectionView: UICollectionView!
    
    // MARK: Properties
    private var gridCollectionViewController: GridCollectionViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        gridCollectionViewController = GridCollectionViewController(collectionView: collectionView)
    }

}

