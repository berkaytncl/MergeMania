//
//  View.swift
//  Game2048
//
//  Created by Berkay Tuncel on 26.02.2024.
//

import SwiftUI

extension View {
    func showAlert<T: AlertProtocol>(alert: Binding<T?>) -> some View {
        self
            .alert(Text(NSLocalizedString(alert.wrappedValue?.title ?? "Error", comment: "")), isPresented: Binding(value: alert), actions: {
                alert.wrappedValue?.buttons
            }, message: {
                if let subtitle = alert.wrappedValue?.subtitle {
                    Text(NSLocalizedString(subtitle, comment: ""))
                }
            })
    }
}

extension View {
    func scoreBackground() -> some View {
        modifier(ScoreBackgroundViewModifier())
    }
}

struct ScoreBackgroundViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .fontWeight(.bold)
            .font(.system(size: 26))
            .padding(4)
            .padding(.horizontal)
            .foregroundStyle(Color(.accent))
            .background(Color(.secondaryBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.bottom)
    }
}
