//
//  FileManager.swift
//  Game2048
//
//  Created by Berkay Tuncel on 11.03.2024.
//

import Foundation

extension FileManager {
    static func documentsPath(key: String) -> URL {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appending(path: "\(key).txt")
    }
}
