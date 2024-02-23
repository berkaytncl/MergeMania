//
//  AlertProtocol.swift
//  Game2048
//
//  Created by Berkay Tuncel on 7.03.2024.
//

import SwiftUI

protocol AlertProtocol {
    var title: String { get }
    var subtitle: String? { get }
    var buttons: AnyView { get }
}
