//
//  TileView.swift
//  Game2048
//
//  Created by Berkay Tuncel on 28.02.2024.
//

import SwiftUI

struct TileView: View {
    
    @State var tile: Tile
    
    var body: some View {
        ZStack {
            setTileColor(numb: tile.value)
                .clipShape(RoundedRectangle(cornerRadius: 4))
            
            Text(tile.value.description)
                .padding(.horizontal, 4)
                .foregroundStyle(setNumberTitleColor(numb: tile.value))
                .fontWeight(.black)
                .font(.system(size: 20))
                .lineLimit(1)
                .minimumScaleFactor(0.3)
            
            Rectangle()
                .fill(Color(.background))
                .onAppear {
                    withAnimation {
                        tile.isNewGenerated = false
                    }
                }
                .opacity(tile.isNewGenerated ? 1 : 0)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

extension TileView {
    private func setTileColor(numb: Int) -> Color {
        switch numb.exponent {
        case 1:
            return Color(.color2)
        case 2:
            return Color(.color4)
        case 3:
            return Color(.color8)
        case 4:
            return Color(.color16)
        case 5:
            return Color(.color32)
        case 6:
            return Color(.color64)
        case 7...11:
            return Color(.color128To2048)
        case 12...:
            return Color.yellow
        default:
            return Color(.background)
        }
    }
    
    private func setNumberTitleColor(numb: Int) -> Color {
        switch numb.exponent {
        case 1...2:
            return Color(.secondaryTile)
        case 3...:
            return Color(.tile)
        default:
            return Color(.background)
        }
    }
}

#Preview {
    TileView(tile: Tile(value: 2, merged: false))
}
