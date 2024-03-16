//
//  MyButtonStyle.swift
//  Focal
//
//  Created by Niek van de Pas on 16/03/2024.
//


import SwiftUI
struct MyButtonStyle: ButtonStyle {
    @Environment(\.customFocus) var focus

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(focus ? 1.2 : 1)
    }
}

struct CustomFocusKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    var customFocus: Bool {
        get { self[CustomFocusKey.self] }
        set { self[CustomFocusKey.self] = newValue }
    }
}

struct CustomFocusModifier: ViewModifier {
    @FocusState var focus: Bool

    func body(content: Content) -> some View {
        content
            .focused($focus)
            .environment(\.customFocus, focus)
    }
}

extension View {
    func customFocus() -> some View {
        modifier(CustomFocusModifier())
    }
}
