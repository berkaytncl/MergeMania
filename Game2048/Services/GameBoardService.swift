//
//  GameBoardService.swift
//  Game2048
//
//  Created by Berkay Tuncel on 23.02.2024.
//

import SwiftUI
import Combine

enum GameBoardError: Error, Equatable {
    case noMoreMove
    case noEmptyTile
}

final class GameBoardService {
    
    @Published var game: Game
    @Published var error: GameBoardError?
    @Published var bestScores: [BestScore] = []
    private var lastSelectedEmptyIndexes: (Int, Int)?
    
    private let moveManager = MoveManager.instance
    private let latestGamesManager = LatestGamesDataManager.instance
    private let bestScoresManager = BestScoresDataManager.instance
    private var cancellables = Set<AnyCancellable>()
    
    init(boardSize: Int) {
        game = Game(boardSize: boardSize)
        spawnTile()
        checkSavedGame()
        addSubscribers()
    }
    
    private func addSubscribers() {
        bestScoresManager.$bestScores
            .sink { [weak self] bestScores in
                self?.bestScores = bestScores
            }
            .store(in: &cancellables)
    }
    
    private func checkSavedGame() {
        guard
            let entity = latestGamesManager.savedEntities.first(where: { $0.boardSize == game.boardSize }),
            let board = latestGamesManager.tryGetSavedBoard(entity: entity) else { return }
        game.board = board
        game.score = Int(entity.score)
    }
}

extension GameBoardService {
    func move(_ direction: MoveDirection) {
        moveManager.move(direction, game: &game)
        if game.isMoved {
            spawnTile()
            preparingForNextMove()
        }
    }
    
    func cleanGame() {
        error = nil
        game.newGame()
        spawnTile()
    }
}

extension GameBoardService {
    private func preparingForNextMove() {
        game.isMoved = false
        
        if checkAnyPossibleMove() {
            for (i, boardRow) in game.board.enumerated() {
                for (j, _) in boardRow.enumerated() {
                    game.board[i][j].merged = false
                }
            }
        }
    }
    
    private func checkAnyPossibleMove() -> Bool {
        do {
            try anyPossibleMove()
            latestGamesManager.updateLatestGamesData(game: game)
            return true
        } catch GameBoardError.noMoreMove {
            error = .noMoreMove
            latestGamesManager.updateLatestGamesData(game: game, isGameOver: true)
            bestScoresManager.newScore(BestScore(boardSize: game.boardSize, score: game.score))
        } catch {}
        return false
    }
    
    private func anyPossibleMove() throws {
        if !moveManager.anyPossibleMove(game: game) {
            throw GameBoardError.noMoreMove
        }
    }
    
    private func spawnTile() {
        do {
            let selectedEmptyIndexes = try findRandomEmptyIndex()
            game.board[selectedEmptyIndexes.0][selectedEmptyIndexes.1] = Tile(value: newRandomNumber(), merged: false, isNewGenerated: true)
            if let lastSelectedEmptyIndexes {
                game.board[lastSelectedEmptyIndexes.0][lastSelectedEmptyIndexes.1].isNewGenerated = false
            }
            lastSelectedEmptyIndexes = selectedEmptyIndexes
        } catch {}
    }
    
    private func findRandomEmptyIndex() throws -> (Int, Int) {
        var emptyIndexes: [(Int,Int)] = []
        for (i, boardRow) in game.board.enumerated() {
            for (j, tile) in boardRow.enumerated() {
                if tile.value == 0 {
                    emptyIndexes.append((i, j))
                }
            }
        }
        guard let index = emptyIndexes.randomElement() else { throw GameBoardError.noEmptyTile }
        return index
    }
    
    private func newRandomNumber() -> Int {
        Int.random(in: 1...10) < 2 ? 4 : 2
    }
}
