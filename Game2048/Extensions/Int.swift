//
//  Int.swift
//  Game2048
//
//  Created by Berkay Tuncel on 4.03.2024.
//

import Foundation

extension Int {
    var exponent: CGFloat {
        log(CGFloat(self)) / log(2)
    }
}
