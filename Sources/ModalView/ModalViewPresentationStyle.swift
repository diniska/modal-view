//
//  ModalViewPresentationStyle.swift
//  ModalView
//
//  Created by Denis Chaschin on 24.01.2026.
//  Copyright © 2026 Denis Chaschin. All rights reserved.
//

public enum ModalViewPresentationStyle {
    case sheet
    case fullScreenCover
    
    public static let `default`: ModalViewPresentationStyle = .sheet
}

#if canImport(SwiftUI) && canImport(Combine) && (arch(arm64) || arch(x86_64))
// arm64 and x86_64 used for compatibility with Xcode 13. More context here: https://stackoverflow.com/a/61954608

import SwiftUI

@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
public extension View {
    func modalViewPresentationStyle(_ style: ModalViewPresentationStyle?) -> some View {
        transformEnvironment(\.modalViewPresentationStyle) {
            $0 = style ?? .default
        }
    }
}

// MARK: - Environment

@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
private struct ModalViewPresentationStyleEnvironmentKey: EnvironmentKey {
    static let defaultValue: ModalViewPresentationStyle = .default
}

@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
extension EnvironmentValues {
    var modalViewPresentationStyle: ModalViewPresentationStyle {
        get { self[ModalViewPresentationStyleEnvironmentKey.self] }
        set { self[ModalViewPresentationStyleEnvironmentKey.self] = newValue }
    }
}

#endif
