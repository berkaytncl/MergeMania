//
//  Tile.swift
//  Game2048
//
//  Created by Berkay Tuncel on 28.02.2024.
//

import Foundation

typealias Tiles = [Tile]

struct Tile: Codable, Identifiable, Hashable {
    var id = UUID().uuidString
    var value: Int
    var merged: Bool
    var isNewGenerated: Bool = false
}
