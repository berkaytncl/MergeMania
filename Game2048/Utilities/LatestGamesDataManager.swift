//
//  LatestGamesDataManager.swift
//  Game2048
//
//  Created by Berkay Tuncel on 28.02.2024.
//

import Foundation
import CoreData

final class LatestGamesDataManager {
    
    static let instance = LatestGamesDataManager()
    
    private let container: NSPersistentContainer
    private let containerName: String = "LatestGamesContainer"
    private let entityName: String = "LatestGamesEntity"
    
    @Published var savedEntities: [LatestGamesEntity] = []
    @Published var savedBoardSizes: [Int] = []
    
    private init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error {
                debugPrint("Error loading Core Data! \(error)")
            }
            self.getLatestGamesData()
        }
    }
    
    private func getLatestGamesData() {
        let request = NSFetchRequest<LatestGamesEntity>(entityName: entityName)
        do {
            savedBoardSizes = []
            savedEntities = try container.viewContext.fetch(request)
            savedEntities.forEach { entity in
                savedBoardSizes.append(Int(entity.boardSize))
            }
        } catch {
            debugPrint("Error fetching Portfolio Entities. \(error)")
        }
    }
}

extension LatestGamesDataManager{
    func updateLatestGamesData(game: Game, isGameOver: Bool = false) {
        if let entity = savedEntities.first(where: { $0.boardSize == game.boardSize }) {
            if isGameOver {
                delete(entity: entity)
                return
            }
            update(entity: entity, game: game)
        } else {
            if !isGameOver {
                add(game: game)
            }
        }
    }
    
    func refreshGame(boardSize: Int) {
        if let entity = savedEntities.first(where: { $0.boardSize == boardSize }) {
            delete(entity: entity)
        }
    }
    
    func tryGetSavedBoard(entity: LatestGamesEntity) -> Board? {
        do {
            guard let data = entity.boardData else { return nil }
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(Board.self, from: data)
            return decodedData
        } catch {
            return nil
        }
    }
}

extension LatestGamesDataManager{
    private func add(game: Game) {
        let entity = LatestGamesEntity(context: container.viewContext)
        entity.boardSize = Int16(game.boardSize)
        entity.score = Int64(game.score)
        entity.boardData = boardToData(board: game.board)
        applyChanges()
    }
    
    private func update(entity: LatestGamesEntity, game: Game) {
        entity.boardData = boardToData(board: game.board)
        entity.score = Int64(game.score)
        applyChanges()
    }
    
    private func delete(entity: LatestGamesEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch {
            debugPrint("Error saving to Core Data. \(error)")
        }
    }
    
    private func applyChanges() {
        save()
        getLatestGamesData()
    }
    
    private func boardToData(board: Board) -> Data? {
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(board)
            return jsonData
        } catch {
            return nil
        }
    }
}
