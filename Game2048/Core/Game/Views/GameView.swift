//
//  GameView.swift
//  Game2048
//
//  Created by Berkay Tuncel on 23.02.2024.
//

import SwiftUI

struct GameView: View {
    
    @Environment(\.dismiss) var dismissScreen
    
    @StateObject private var viewModel: GameViewModel
    @State private var alert: GameOverAlert? = nil
    @State private var endDragOffset: CGSize = .zero
    
    init(boardSize: Int) {
        self._viewModel = StateObject(wrappedValue: GameViewModel(boardSize: boardSize))
    }
    
    var body: some View {
        ZStack {
            Color(.background)
                .ignoresSafeArea()
            
            VStack {
                bestScoreLabel
                scoreLabel
                gameBoard
            }
        }
        .showAlert(alert: $alert)
        .navigationTitle(viewModel.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismissScreen()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.accent)
                }
            }
        })
        .gesture(drag)
        .onChange(of: endDragOffset) { _, offset in
            viewModel.handleSwipe(offset: offset)
        }
        .onChange(of: viewModel.error) { _, newValue in
            if newValue != nil {
                alert = .noMoreMovementLeft(onNewGamePressed: {
                    viewModel.newGame()
                }, onHomePressed: {
                    viewModel.error = nil
                    dismissScreen()
                })
            }
        }
    }
}

extension GameView {
    enum GameOverAlert: AlertProtocol {
        case noMoreMovementLeft(onNewGamePressed: () -> (), onHomePressed: () -> ())
        
        var title: String {
            switch self {
            case .noMoreMovementLeft:
                "You have no more movement left."
            }
        }
        
        var subtitle: String? {
            switch self {
            case .noMoreMovementLeft:
                "Do you want to start a new game?"
            }
        }
        
        var buttons: AnyView {
            AnyView(getButtonsForAlert)
        }
        
        @ViewBuilder private var getButtonsForAlert: some View {
            switch self {
            case .noMoreMovementLeft(onNewGamePressed: let onNewGamePressed, onHomePressed: let onHomePressed):
                Button("Home") {
                    onHomePressed()
                }
                Button("New Game") {
                    onNewGamePressed()
                }
            }
        }
    }
}

extension GameView {
    private var drag: some Gesture {
        DragGesture()
            .onEnded { value in
                endDragOffset = value.translation
            }
    }
    
    @ViewBuilder private var bestScoreLabel: some View {
        HStack {
            Text("Best: ")
            if let bestScore = viewModel.bestScores.first(where: { $0.boardSize == viewModel.game.boardSize }) {
                Text(bestScore.score.description)
            } else {
                Text("-")
            }
        }
        .scoreBackground()
    }
    
    private var scoreLabel: some View {
        HStack {
            Text("Score: ")
            Text(viewModel.game.score.description)
        }
        .scoreBackground()
    }
    
    private var gameBoard: some View {
        GameBoardView(board: viewModel.game.board)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding()
    }
}

#Preview {
    NavigationStack {
        GameView(boardSize: 4)
    }
}
