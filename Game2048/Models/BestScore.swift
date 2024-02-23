//
//  BestScore.swift
//  Game2048
//
//  Created by Berkay Tuncel on 11.03.2024.
//

import Foundation

struct BestScore: Codable, Hashable {
    let boardSize: Int
    let score: Int
}
