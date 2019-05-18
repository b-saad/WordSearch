//
//  WordSearchGenerator.swift
//  WordSearch
//
//  Created by Bilal Saad on 2019-05-17.
//  Copyright © 2019 Bilal Saad. All rights reserved.
//

import UIKit

struct WordSearchGenerator {
    private let numRows: Int
    private let numColumns: Int
    private let words: [String]
    
    init(numRows: Int, numColumns: Int, words: [String]) {
        self.numRows = numRows
        self.numColumns = numColumns
        self.words = words.map({$0.uppercased()})
    }
    
    func generateWordSearch() -> [[String]] {
        return fillWordSearch()
    }
}

// MARK: Utility
private extension WordSearchGenerator {
    func generateEmptyWordSearch() -> [[String]] {
        var empty2DArray = [[String]]()
        
        for _ in (1...numRows) {
            empty2DArray.append(Array.init(repeating: "", count: numColumns))
        }
        
        return empty2DArray
    }
    
    func fillWordSearch() -> [[String]] {
        var wordSearch = generateEmptyWordSearch()
        
        for word in words {
            var orientationsAttempted = [WordOrientation]()
            var remainingOrientations = WordOrientation.allOrientations()
            while remainingOrientations.count != 0 {
                guard let randomOrientation = remainingOrientations.randomElement() else { fatalError("WordOrientations allOrientations empty") }
                orientationsAttempted.append(randomOrientation)
                remainingOrientations.removeAll { (orientation: WordOrientation) -> Bool in
                    orientation == randomOrientation
                }
                guard let newWordSearch = insert(word, wordSearch: wordSearch, orientation: randomOrientation) else { continue }
                wordSearch = newWordSearch
                break
            }
        }
        
        return fillBlanksWithRandomChar(wordSearch: wordSearch)
    }
    
    func insert(_ word: String, wordSearch: [[String]], orientation: WordOrientation) -> [[String]]? {
        switch orientation {
        case .Vertical(let option):
            if let newWordSearch = insertWordVertically(word, wordSearch: wordSearch, option: option) {
                return newWordSearch
            }
        case .Horizontal(let option):
            if let newWordSearch = insertWordHorizontally(word, wordSearch: wordSearch, option: option) {
                return newWordSearch
            }
        case .diagonal(let vOption, let hOption):
            if let newWordSearch = insertWordDiagonally(word, wordSearch: wordSearch, verticalOption: vOption, horizontalOption: hOption) {
                return newWordSearch
            }
        }
        return nil
    }
    
    func insertWordVertically(_ word: String, wordSearch: [[String]], option: WordOrientation.VerticalOptions) -> [[String]]? {
        guard let numColumns = wordSearch.first?.count else { return nil }
        let numRows = wordSearch.count
        guard word.count <= numRows else { return nil }
        var newWordSearch = wordSearch
        
        let direction = option == .TopToBottom ? 1 : -1
        
        var columnsAttempted = [Int]()
        var remainingColumns = Array(0..<numRows)
        while columnsAttempted.count != numColumns {
            guard let randomColumn = remainingColumns.randomElement() else { fatalError("colmumns array empty")}
            columnsAttempted.append(randomColumn)
            remainingColumns.removeAll { $0 == randomColumn }
            
            var rowsAttempted = [Int]()
            var remainingRows = Array(0..<numRows)
            var canBeInserted = true
            while rowsAttempted.count != numRows {
                guard let randomRow = remainingRows.randomElement() else { fatalError("rows array empty")}
                rowsAttempted.append(randomRow)
                remainingRows.removeAll { $0 == randomRow }
                
                if wordSearch[randomRow][randomColumn].isEmpty {
                    for (i, char) in word.enumerated() {
                        guard (randomRow + i * direction) < numRows,
                            (randomRow + i * direction) >= 0,
                            (wordSearch[randomRow + (i * direction)][randomColumn].isEmpty ||
                                wordSearch[randomRow + (i * direction)][randomColumn] == String(char))
                        else {
                            canBeInserted = false
                            break
                        }
                    }
                } else {
                    continue
                }
                if canBeInserted {
                    for (i, char) in word.enumerated() {
                        newWordSearch[randomRow + (i * direction)][randomColumn] = String(char)
                    }
                    return newWordSearch
                }
            }
        }
        return nil
    }
    
    func insertWordHorizontally(_ word: String, wordSearch: [[String]], option: WordOrientation.HorizontalOptions) -> [[String]]? {
        guard let numColumns = wordSearch.first?.count else { return nil }
        let numRows = wordSearch.count
        guard word.count <= numColumns else { return nil }
        var newWordSearch = wordSearch
        
        let direction = option == .LeftToRight ? 1 : -1
        
        var rowsAttempted = [Int]()
        var remainingRows = Array(0..<numRows)
        while rowsAttempted.count != numRows {
            guard let randomRow = remainingRows.randomElement() else { fatalError("rows array empty")}
            rowsAttempted.append(randomRow)
            remainingRows.removeAll { $0 == randomRow }

            var remainingColumns = Array(0..<numRows)
            var columnsAttempted = [Int]()
            var canBeInserted = true
            while columnsAttempted.count != numColumns {
                guard let randomColumn = remainingColumns.randomElement() else { fatalError("colmumns array empty")}
                columnsAttempted.append(randomColumn)
                remainingColumns.removeAll { $0 == randomColumn }
                
                if wordSearch[randomRow][randomColumn].isEmpty {
                   for (i, char) in word.enumerated() {
                        guard (randomColumn + i * direction) < numColumns,
                            (randomColumn + i * direction) >= 0,
                            (wordSearch[randomRow][randomColumn + (i * direction)].isEmpty || wordSearch[randomRow][randomColumn + (i * direction)] == String(char))
                        else {
                            canBeInserted = false
                            break
                        }
                    }
                } else {
                    continue
                }
                if canBeInserted {
                    for (i, char) in word.enumerated() {
                        newWordSearch[randomRow][randomColumn + (i * direction)] = String(char)
                    }
                    return newWordSearch
                }
            }
        }
        return nil
    }
    
    func insertWordDiagonally(_ word: String, wordSearch: [[String]], verticalOption: WordOrientation.VerticalOptions, horizontalOption: WordOrientation.HorizontalOptions) -> [[String]]? {
        guard let numColumns = wordSearch.first?.count else { return nil }
        let numRows = wordSearch.count
        guard word.count <= numRows, word.count <= numColumns else { return nil }
        var newWordSearch = wordSearch
        
        let verticalDirection = verticalOption == .TopToBottom ? 1 : -1
        let horizontalDirection = horizontalOption == .LeftToRight ? 1 : -1
        
        var rowsAttempted = [Int]()
        var remainingRows = Array(0..<numRows)
        while rowsAttempted.count != numRows {
            guard let randomRow = remainingRows.randomElement() else { fatalError("rows array empty")}
            rowsAttempted.append(randomRow)
            remainingRows.removeAll { $0 == randomRow }
            
            var remainingColumns = Array(0..<numRows)
            var columnsAttempted = [Int]()
            var canBeInserted = true
            while columnsAttempted.count != numColumns {
                guard let randomColumn = remainingColumns.randomElement() else { fatalError("colmumns array empty")}
                columnsAttempted.append(randomColumn)
                remainingColumns.removeAll { $0 == randomColumn }
                
                if wordSearch[randomRow][randomColumn].isEmpty {
                    for (i, char) in word.enumerated()  {
                      
                        guard (randomRow + i * verticalDirection) < numRows,
                            (randomRow + i * verticalDirection) >= 0,
                            (randomColumn + i * horizontalDirection) < numColumns,
                            (randomColumn + i * horizontalDirection) >= 0,
                            (wordSearch[randomRow + (i * verticalDirection)][randomColumn + (i * horizontalDirection)].isEmpty ||
                                wordSearch[randomRow + (i * verticalDirection)][randomColumn + (i * horizontalDirection)] ==  String(char))
                        else {
                            canBeInserted = false
                            break
                        }
                    }
                } else {
                    continue
                }
                if canBeInserted {
                    for (i, char) in word.enumerated() {
                        newWordSearch[randomRow + (i * verticalDirection)][randomColumn + (i * horizontalDirection)] = String(char)
                    }
                    return newWordSearch
                }
            }
        }
        return nil
    }
    
    func fillBlanksWithRandomChar(wordSearch: [[String]]) -> [[String]] {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        var newWordSearch = generateEmptyWordSearch()
        for i in (0..<wordSearch.count) {
            for j in (0..<wordSearch[i].count) {
                if wordSearch[i][j].isEmpty {
                    if let randomLetter = letters.randomElement() {
                        newWordSearch[i][j] = String(randomLetter)
                    }
                } else {
                    newWordSearch[i][j] = wordSearch[i][j]
                }
            }
        }
        return newWordSearch
    }
}

fileprivate enum WordOrientation: Equatable {
    case Vertical(VerticalOptions)
    case Horizontal(HorizontalOptions)
    case diagonal(VerticalOptions, HorizontalOptions)
    
    enum VerticalOptions: Int, CaseIterable {
        case TopToBottom
        case BottomToTop
    }
    
    enum HorizontalOptions: Int, CaseIterable {
        case LeftToRight
        case RightToLeft
    }
    
    static func allOrientations() -> [WordOrientation] {
        return [
            .Vertical(.TopToBottom),
            .Vertical(.BottomToTop),
            .Horizontal(.LeftToRight),
            .Horizontal(.RightToLeft),
            .diagonal(.TopToBottom, .LeftToRight),
            .diagonal(.TopToBottom, .RightToLeft),
            .diagonal(.BottomToTop, .LeftToRight),
            .diagonal(.BottomToTop, .RightToLeft)
        ]
    }
}
