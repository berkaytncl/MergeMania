//
//  GameBoardView.swift
//  Game2048
//
//  Created by Berkay Tuncel on 26.02.2024.
//

import SwiftUI

struct GameBoardView: View {
    
    private let board: Board
    private let boardSize: Int
    
    init(board: Board) {
        self.board = board
        boardSize = board.count
    }
    
    init(boardSize: Int) {
        board = Board.example(boardSize: boardSize)
        self.boardSize = boardSize
    }
    
    var body: some View {
        VStack(spacing: 4) {
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 4), count: boardSize), spacing: 4) {
                ForEach(board, id: \.self) { row in
                    ForEach(row, id: \.self) { tile in
                        TileView(tile: tile)
                            .aspectRatio(1, contentMode: .fit)
                    }
                }
            }
        }
        .padding(4)
        .background(Color(.boardBackground))
    }
}

#Preview {
    GameBoardView(boardSize: 4)
}
