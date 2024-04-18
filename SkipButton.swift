//
//  SkipButton.swift
//  Focal
//
//  Created by Niek van de Pas on 18/04/2024.
//

import SwiftUI

struct SkipButton: View {
    let shown: Bool
    let skipTimer: () -> Void

    var body: some View {
        if shown {
            Button(action: {
                skipTimer()
            }) {
                Text("Skip »")
                    .foregroundStyle(.primaryButton)
                    .font(.title3)
            }
            .buttonStyle(PlainButtonStyle())
            .frame(height: 20)
        }
        else {
            Spacer()
                .frame(height: 20)
        }
    }
}

#Preview {
    return SkipButton(shown: true, skipTimer: {})
        .frame(width: 200, height: 300)
}
