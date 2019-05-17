//
//  GridCollectionViewController.swift
//  WordSearch
//
//  Created by Bilal Saad on 2019-05-16.
//  Copyright © 2019 Bilal Saad. All rights reserved.
//

import UIKit

final class GridCollectionViewController: NSObject {
    
    // MARK: Properties
    private let collectionView: UICollectionView
    private var data = [[Int]]()
    private var words = [
        "123456",
        "2233445566",
        "99897969",
        "41424344454647"
    ]
    private var wordsFound = [String]()
    private var remainingWords = [String]()
    private var selectedCells = [IndexPath]()
    private var selectionDirection: SelectionDirection = .none
    
    // MARK: Initialization
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        
        data.append(contentsOf:
            [Array(0...9),
             Array(10...19),
             Array(20...29),
             Array(30...39),
             Array(40...49),
             Array(50...59),
             Array(60...69),
             Array(70...79),
             Array(80...89),
             Array(90...99)]
        )
        
        collectionView.register(.GridCell, forCellWithReuseIdentifier: String(describing: GridCell.self))
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupCollectionView()
        
        remainingWords = words
    }
}

extension GridCollectionViewController: UIGestureRecognizerDelegate {
    
    func setupCollectionView() {
        collectionView.canCancelContentTouches = false
        collectionView.allowsMultipleSelection = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan(toSelectCells:)))
        panGesture.delegate = self
        collectionView.addGestureRecognizer(panGesture)
    }
    
    @objc private func didPan(toSelectCells panGesture: UIPanGestureRecognizer) {
        let point = panGesture.location(in: collectionView)
        switch panGesture.state {
            case .began:
                if let indexPath = collectionView.indexPathForItem(at: point) {
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
                    selectedCells.append(indexPath)
                }
            case .changed:
                if let indexPath = collectionView.indexPathForItem(at: point) {
                    guard let firstIndexPath = selectedCells.first,
                        let lastIndexPath = selectedCells.last,
                        !selectedCells.contains(indexPath)
                    else { return }
                    let row = indexPath.section
                    let column = indexPath.row
                    if selectionDirection == .none  {
                        if firstIndexPath.section == row {
                            selectionDirection = .horizontal
                        } else if firstIndexPath.row == column {
                            selectionDirection = .vertical
                        } else {
                            selectionDirection = .diagonal
                        }
                        print(selectionDirection)
                    }
                    switch selectionDirection {
                    case .vertical:
                        if firstIndexPath.row == column && ((lastIndexPath.section == row + 1) || (lastIndexPath.section == row - 1)) {
                            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
                            selectedCells.append(indexPath)
                        }
                    case .horizontal:
                        if firstIndexPath.section == row && ((lastIndexPath.row == column + 1) || (lastIndexPath.row == column - 1)) {
                            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
                            selectedCells.append(indexPath)
                        }
                    case .diagonal:
                        if (lastIndexPath.row == column + 1 && (lastIndexPath.section == row + 1 || lastIndexPath.section == row - 1)) ||
                            (lastIndexPath.row == column - 1 && (lastIndexPath.section == row + 1 || lastIndexPath.section == row - 1)) {
                            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
                            selectedCells.append(indexPath)
                        }
                    default:
                        return
                    }
                }
            default:
                var selectedChars = ""
                var wordFound = false
                for indexPath in selectedCells {
                    selectedChars += String(data[indexPath.section][indexPath.row])
                }
                
                print(selectedChars)
                print(remainingWords)
                if remainingWords.contains(selectedChars) || remainingWords.contains(String(selectedChars.reversed())){
                    remainingWords.removeAll { $0 == selectedChars }
                    wordsFound.append(selectedChars)
                    wordFound = true
                }
                for indexPath in selectedCells {
                    if wordFound, let cell = collectionView.cellForItem(at: indexPath) as? GridCell {
                        cell.selectPermentantly()
                    }
                    collectionView.deselectItem(at: indexPath, animated: true)
                }
                selectedCells.removeAll()
                selectionDirection = .none
        }
    }
}

// MARK - UICollectionViewDelegate
extension GridCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !selectedCells.contains(indexPath) {
            collectionView.deselectItem(at: indexPath, animated: false)
        }
    }
}

// MARK - UICollectionViewDataSource
extension GridCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let column = indexPath.row
        let row = indexPath.section
        let number = data[row][column]
        let cell: GridCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.set(text: String(number))
        return cell
    }
    
}

// MARK - UICollectionViewDelegateFlowLayout
extension GridCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard !data.isEmpty else { return CGSize.zero }
        let height = collectionView.frame.height / CGFloat(data.count)
        let width = collectionView.frame.width / CGFloat(data[0].count)
        return CGSize(width: width, height: height)
    }
}

private enum SelectionDirection {
    case none
    case vertical
    case horizontal
    case diagonal
}
