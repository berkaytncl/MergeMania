//
//  MoveManager.swift
//  Game2048
//
//  Created by Berkay Tuncel on 23.02.2024.
//

import SwiftUI

enum MoveDirection: CaseIterable {
    case left, right, up, down
}

final class MoveManager {
    static var instance = MoveManager()
    private init() {}
    
    func move(_ direction: MoveDirection, game: inout Game) {
        switch direction {
        case .left:
            moveLeft(game: &game)
        case .right:
            moveRight(game: &game)
        case .up:
            moveUp(game: &game)
        case .down:
            moveDown(game: &game)
        }
    }
    
    func anyPossibleMove(game: Game) -> Bool {
        var game = game
        for direction in MoveDirection.allCases {
            move(direction, game: &game)
            if game.isMoved { return true }
        }
        return game.isMoved
    }
}

extension MoveManager {
    private func moveLeft(game: inout Game) {
        for i in 0..<game.board.count {
            for j in 1..<game.board[0].count {
                if game.board[i][j].value != 0 {
                    var k = j - 1
                    
                    while k >= 0 && game.board[i][k].value == 0 {
                        game.board[i][k].value = game.board[i][k + 1].value
                        game.board[i][k + 1].value = 0
                        k -= 1
                        game.isMoved = true
                    }
                    
                    if k >= 0 && game.board[i][k].value == game.board[i][k + 1].value && !game.board[i][k].merged {
                        game.board[i][k].value *= 2
                        game.board[i][k + 1].value = 0
                        game.board[i][k].merged = true
                        game.score += game.board[i][k].value
                        game.isMoved = true
                    }
                }
            }
        }
    }
    
    private func moveRight(game: inout Game) {
        for i in 0..<game.board.count {
            for j in (0..<game.board[0].count-1).reversed() {
                if game.board[i][j].value != 0 {
                    var k = j + 1
                    
                    while k < game.board.count && game.board[i][k].value == 0 {
                        game.board[i][k].value = game.board[i][k - 1].value
                        game.board[i][k - 1].value = 0
                        k += 1
                        game.isMoved = true
                    }
                    
                    if k < game.board.count && game.board[i][k].value == game.board[i][k - 1].value && !game.board[i][k].merged {
                        game.board[i][k].value *= 2
                        game.board[i][k - 1].value = 0
                        game.board[i][k].merged = true
                        game.score += game.board[i][k].value
                        game.isMoved = true
                    }
                }
            }
        }
    }
    
    private func moveUp(game: inout Game) {
        for j in 0..<game.board.count {
            for i in 1..<game.board[0].count {
                if game.board[i][j].value != 0 {
                    var k = i - 1
                    
                    while k >= 0 && game.board[k][j].value == 0 {
                        game.board[k][j].value = game.board[k + 1][j].value
                        game.board[k + 1][j].value = 0
                        k -= 1
                        game.isMoved = true
                    }
                    
                    if k >= 0 && game.board[k][j].value == game.board[k + 1][j].value && !game.board[k][j].merged {
                        game.board[k][j].value *= 2
                        game.board[k + 1][j].value = 0
                        game.board[k][j].merged = true
                        game.score += game.board[k][j].value
                        game.isMoved = true
                    }
                }
            }
        }
    }
    
    private func moveDown(game: inout Game) {
        for j in 0..<game.board.count {
            for i in (0..<game.board[0].count-1).reversed() {
                if game.board[i][j].value != 0 {
                    var k = i + 1
                    
                    while k < game.board.count && game.board[k][j].value == 0 {
                        game.board[k][j].value = game.board[k - 1][j].value
                        game.board[k - 1][j].value = 0
                        k += 1
                        game.isMoved = true
                    }
                    
                    if k < game.board.count && game.board[k][j].value == game.board[k - 1][j].value && !game.board[k][j].merged {
                        game.board[k][j].value *= 2
                        game.board[k - 1][j].value = 0
                        game.board[k][j].merged = true
                        game.score += game.board[k][j].value
                        game.isMoved = true
                    }
                }
            }
        }
    }
}
