//
//  GameViewModel.swift
//  Game2048
//
//  Created by Berkay Tuncel on 23.02.2024.
//

import Foundation
import Combine

@MainActor
final class GameViewModel: ObservableObject {
    
    @Published var game: Game
    @Published var error: GameBoardError?
    @Published var bestScores: [BestScore] = []
    
    var navigationTitle: String {
        "\(game.boardSize)x\(game.boardSize)"
    }
    
    private let gameBoardService: GameBoardService
    private var cancellables = Set<AnyCancellable>()
    
    init(boardSize: Int) {
        self.gameBoardService = GameBoardService(boardSize: boardSize)
        game = Game(boardSize: boardSize)
        addSubscribers()
    }
    
    private func addSubscribers() {
        gameBoardService.$game
            .combineLatest(gameBoardService.$bestScores, gameBoardService.$error)
            .sink { [weak self] game, bestScores, error in
                guard let self else { return }
                self.game = game
                self.bestScores = bestScores
                self.error = error
            }
            .store(in: &cancellables)
    }
}

extension GameViewModel {
    func newGame() {
        gameBoardService.cleanGame()
    }
    
    func handleSwipe(offset: CGSize) {
        let width = offset.width
        let height = offset.height
        
        if abs(width) > abs(height) {
            if width > 0 {
                gameBoardService.move(.right)
            } else {
                gameBoardService.move(.left)
            }
            return
        }
        
        if height > 0 {
            gameBoardService.move(.down)
        } else {
            gameBoardService.move(.up)
        }
    }
}
