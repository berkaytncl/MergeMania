//
//  Board.swift
//  Game2048
//
//  Created by Berkay Tuncel on 1.03.2024.
//

import Foundation

typealias Board = [Tiles]

extension Board {
    static let potentialBoardSizes: ClosedRange<Int> = 4...8
        
    static func example(boardSize: Int) -> Self {
        return examples[boardSize - 4]
    }
    
    static func setClearBoard(boardSize: Int) -> Self {
        (0..<boardSize).map { _ in
            (0..<boardSize).map { _ in
                Tile(value: 0, merged: false)
            }
        }
    }
    
    static private let examples: [Self] = {
        potentialBoardSizes.map { generateExample(boardSize: $0)}
    }()
    
    static private func generateExample(boardSize: Int) -> Self {
        (0..<boardSize).map { _ in
            (0..<boardSize).map { _ in
                guard Bool.random() else {
                    return Tile(value: 0, merged: false)
                }
                return Tile(value: NSDecimalNumber(decimal: pow(2.0, Int.random(in: 1...13))).intValue, merged: false)
            }
        }
    }
}
