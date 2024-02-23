//
//  BestScoresDataManager.swift
//  Game2048
//
//  Created by Berkay Tuncel on 11.03.2024.
//

import Foundation

final class BestScoresDataManager {
    
    static let instance = BestScoresDataManager()
    private let key = "best_scores"
    
    @Published var bestScores: [BestScore]
    
    private init() {
        do {
            let url = FileManager.documentsPath(key: key)
            let data = try Data(contentsOf: url)
            let object = try JSONDecoder().decode([BestScore].self, from: data)
            bestScores = object
            debugPrint("Success read")
        } catch {
            bestScores = []
            debugPrint("Error reading: \(error.localizedDescription)")
        }
    }
    
    func newScore(_ bestScore: BestScore) {
        if let _ = bestScores
            .filter({ $0.boardSize == bestScore.boardSize })
            .first(where: { $0.score < bestScore.score }) {
            bestScores = bestScores.filter({ $0.boardSize != bestScore.boardSize })
            bestScores.append(bestScore)
            save()
        } else if !bestScores
            .map({ $0.boardSize })
            .contains(bestScore.boardSize) {
            bestScores.append(bestScore)
            save()
        } else {
            debugPrint("Not enought for best score.")
        }
    }
    
    private func save() {
        do {
            let data = try JSONEncoder().encode(bestScores)
            try data.write(to: FileManager.documentsPath(key: key))
            debugPrint("Success saved")
        } catch {
            debugPrint("Error saving: \(error.localizedDescription)")
        }
    }
}
