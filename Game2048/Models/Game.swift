//
//  Game.swift
//  Game2048
//
//  Created by Berkay Tuncel on 29.02.2024.
//

import Foundation

struct Game: Codable {
    var boardSize: Int
    var board: Board
    var score: Int
    var isMoved: Bool
    
    init(boardSize: Int = 4) {
        self.boardSize = boardSize
        score = 0
        board = Board.setClearBoard(boardSize: boardSize)
        isMoved = false
    }
    
    init(boardSize: Int = 4, score: Int, board: Board) {
        self.boardSize = boardSize
        self.score = score
        self.board = board
        self.isMoved = false
    }
    
    mutating func newGame() {
        score = 0
        board = Board.setClearBoard(boardSize: boardSize)
        isMoved = false
    }
}
