//
//  HomeViewModel.swift
//  Game2048
//
//  Created by Berkay Tuncel on 8.03.2024.
//

import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    
    @Published var savedBoardSizes: [Int] = []
    @Published var tempBoardSize: Int = 4
    @Published var selectedBoardSize: Int? = nil
    @Published var bestScores: [BestScore] = []
    
    private let latestGamesManager = LatestGamesDataManager.instance
    private let bestScoresManager = BestScoresDataManager.instance
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        latestGamesManager.$savedBoardSizes
            .sink { [weak self] savedBoardSizes in
                self?.savedBoardSizes = savedBoardSizes
            }
            .store(in: &cancellables)
        
        bestScoresManager.$bestScores
            .sink { [weak self] bestScores in
                self?.bestScores = bestScores
            }
            .store(in: &cancellables)
    }
    
    func endDragHandle(offset: CGSize) {
        if offset.width > 180 {
            if tempBoardSize > 4 {
                tempBoardSize -= 1
            }
        } else if offset.width < -180 {
            if tempBoardSize < 8 {
                tempBoardSize += 1
            }
        }
    }
    
    func newGame() {
        latestGamesManager.refreshGame(boardSize: tempBoardSize)
    }
}
