//
//  HomeView.swift
//  Game2048
//
//  Created by Berkay Tuncel on 23.02.2024.
//

import SwiftUI

struct HomeView: View {
    
    @Namespace private var namespace
    
    @StateObject private var viewModel = HomeViewModel()
    @State private var alert: InfoAlert? = nil
    @State private var offSet: CGSize = .zero
    @State private var endDragOffset: CGSize = .zero
    private let boardHeight: CGFloat = 300
    
    var body: some View {
        ZStack {
            Color(.background)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                scoreLabel
                exampleBoards
                boardSizeInfoSection
                startGameButtons
                Spacer()
                Spacer()
            }
            .showAlert(alert: $alert)
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: Binding(value: $viewModel.selectedBoardSize)) {
                navigateGameView
            }
            .gesture(drag)
            .onChange(of: endDragOffset) { _, endDragOffset in
                withAnimation(.bouncy(duration: 0.75)) {
                    viewModel.endDragHandle(offset: endDragOffset)
                    offSet = .zero
                }
            }
        }
    }
}

extension HomeView {
    enum InfoAlert: AlertProtocol {
        case haveSavedGame(onNewGamePressed: () -> ())
        
        var title: String {
            switch self {
            case .haveSavedGame:
                "There is a previously played and saved game."
            }
        }
        
        var subtitle: String? {
            switch self {
            case .haveSavedGame:
                "Do you want to start a new game?"
            }
        }
        
        var buttons: AnyView {
            AnyView(getButtonsForAlert)
        }
        
        @ViewBuilder private var getButtonsForAlert: some View {
            switch self {
            case .haveSavedGame(onNewGamePressed: let onNewGamePressed):
                Button("New Game") {
                    onNewGamePressed()
                }
                
                Button("Cancel", role: .cancel) {}
            }
        }
    }
}

extension HomeView {
    private var drag: some Gesture {
        DragGesture()
            .onChanged({ value in
                offSet = value.translation
            })
            .onEnded { value in
                endDragOffset = value.translation
            }
    }
    
    private var scoreLabel: some View {
        HStack {
            Text("Best: ")
            if let bestScore = viewModel.bestScores
                .first(where: { $0.boardSize == viewModel.tempBoardSize }) {
                Text(bestScore.score.description)
            } else {
                Text("-")
            }
        }
        .scoreBackground()
    }
    
    private var exampleBoards: some View {
        VStack {
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    ForEach(Board.potentialBoardSizes, id: \.self) { boardSize in
                        GameBoardView(boardSize: boardSize)
                            .frame(width: boardHeight, height: boardHeight)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .frame(width: geometry.size.width)
                    }
                }
                .offset(x: -CGFloat(viewModel.tempBoardSize - 4) * geometry.size.width)
                .offset(x: offSet.width)
            }
            .frame(height: boardHeight)
        }
    }
    
    private var boardSizeInfoSection: some View {
        HStack {
            ForEach(Board.potentialBoardSizes, id: \.self) { boardSize in
                ZStack {
                    if boardSize == viewModel.tempBoardSize {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.selected)
                            .matchedGeometryEffect(id: "boardSize_underline", in: namespace)
                            .frame(width: 30, height: 3)
                            .offset(y: 15)
                    }
                    
                    Text("\(boardSize)x\(boardSize)")
                        .fontWeight(.bold)
                        .foregroundStyle(viewModel.tempBoardSize == boardSize ? .selected : .accent)
                        .onTapGesture {
                            withAnimation(.bouncy(duration: 0.75)) {
                                viewModel.tempBoardSize = boardSize
                            }
                        }
                }
            }
            .padding(.horizontal, 4)
            .padding(.vertical)
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal)
    }
    
    private var startGameButtons: some View {
        VStack {
            if viewModel.savedBoardSizes.contains(viewModel.tempBoardSize) {
                Button(action: {
                    segue()
                }, label: {
                    Text("Continue")
                        .padding(.horizontal)
                })
                .padding(.bottom)
                
                Button(action: {
                    alert = .haveSavedGame(onNewGamePressed: {
                        viewModel.newGame()
                        segue()
                    })
                }, label: {
                    Text("New Game")
                        .padding(.horizontal)
                })
            } else {
                Button(action: {
                    segue()
                }, label: {
                    Text("Start Game")
                        .padding(.horizontal)
                })
                .padding(.bottom)
                
                Button(action: {
                    
                }, label: {
                    Text("Start Game")
                        .padding(.horizontal)
                })
                .opacity(0)
            }
        }
        .fontWeight(.bold)
        .font(.system(size: 26))
        .buttonStyle(.bordered)
        .buttonBorderShape(.capsule)
        .tint(.accent)
        .padding()
    }
    
    @ViewBuilder private var navigateGameView: some View {
        if let selectedBoardSize = viewModel.selectedBoardSize {
            GameView(boardSize: selectedBoardSize)
        } else {
            GameView(boardSize: 4)
        }
    }
    
    private func segue() {
        viewModel.selectedBoardSize = viewModel.tempBoardSize
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
