//
//  ModalView.swift
//  ModalView
//
//  Created by Denis Chaschin on 22.09.2019.
//  Copyright © 2019 Denis Chaschin. All rights reserved.
//

#if canImport(SwiftUI) && canImport(Combine) && (arch(arm64) || arch(x86_64))
// arm64 and x86_64 used for compatibility with Xcode 13. More context here: https://stackoverflow.com/a/61954608

import SwiftUI

/// Container of a view that contains ModalLink in its hierarchy
@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
public struct ModalPresenter<Content: View>: View {
    private var content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        #if os(macOS)
        content
            .modifier(ModalPresenterBeforeIOS14())
        #else
        if #available(iOS 14, tvOS 14, watchOS 7, *) {
            content
                .modifier(ModalPresenterIOS14())
        } else {
            content
                .modifier(ModalPresenterBeforeIOS14())
        }
        #endif
    }
}

@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
private final class Pipe : ObservableObject {
    struct Content<V: View>: Identifiable {
        fileprivate typealias ID = String
        fileprivate let id = UUID().uuidString
        var style: ModalViewPresentationStyle
        var view: V
    }
    
    @Published var content: Content<AnyView>? = nil
    
    var sheetContent: Content<AnyView>? {
        get { content.flatMap { $0.style == .sheet ? $0 : nil } }
        set { content = newValue }
    }
    
    var fullScreenCoverContent: Content<AnyView>? {
        get { content.flatMap { $0.style == .fullScreenCover ? $0 : nil } }
        set { content = newValue }
    }
}

@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
private struct ModalPresenterBeforeIOS14: ViewModifier {
    @ObservedObject private var modalView = Pipe()
    
    func body(content: Content) -> some View {
        content
            .environmentObject(modalView)
            .sheet(item: $modalView.content, content: { $0.view })
    }
}

@available(iOS 14, tvOS 14, watchOS 7, *)
@available(macOS, unavailable)
private struct ModalPresenterIOS14: ViewModifier {
    @ObservedObject private var modalView = Pipe()
    
    func body(content: Content) -> some View {
        content
            .environmentObject(modalView)
            .sheet(item: $modalView.sheetContent, content: { $0.view })
            .fullScreenCover(item: $modalView.fullScreenCoverContent, content: { $0.view })
    }
}

/// An interactable element that presents a modal view
@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
public struct ModalLink<Label, Destination> : View where Label : View, Destination : View  {
    public typealias DestinationBuilder = (_ dismiss: @escaping() -> ()) -> Destination
    @EnvironmentObject private var modalView: Pipe
    
    private enum DestinationProvider {
        case view(Destination)
        case builder(DestinationBuilder)
        
        func destination(dismiss: @escaping () -> ()) -> Destination {
            switch self {
            case let .view(view):
                return view
            case let .builder(build):
                return build(dismiss)
            }
        }
    }
    
    private var destinationProvider: DestinationProvider
    private var label: Label
    
    @Environment(\.modalViewPresentationStyle)
    private var presentationStyle
    
    /// Default initializer
    public init(destination: Destination, @ViewBuilder label: () -> Label) {
        self.destinationProvider = .view(destination)
        self.label = label()
    }
    
    /// Use this initializer when `dismiss` method is needed in the modal view
    public init(@ViewBuilder destination: @escaping DestinationBuilder, @ViewBuilder label: () -> Label) {
        self.destinationProvider = .builder(destination)
        self.label = label()
    }
    
    public var body: some View {
        Button(action: presentModalView){ label }
    }
    
    private func presentModalView() {
        modalView.content = Pipe.Content(
            style: presentationStyle,
            view: AnyView(destinationProvider.destination(dismiss: dismissModalView))
        )
    }
    
    private func dismissModalView() {
        modalView.content = nil
    }
}

#if DEBUG

@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
private struct ModalLink_Preview: PreviewProvider {
    static var previews: some View {
        ModalPresenter {
            List {
                ModalLink(destination: Text("Destination 1")) {
                    Text("Open 1")
                }
                ModalLink(destination: Text("Destination 2")) {
                    Text("Open 2")
                }
                
                ModalLink(destination: { dismiss in
                    VStack {
                        Text("Full screen cover")
                        Button("Dismiss", action: dismiss)
                    }
                }) {
                    Text("Open 3")
                }
                .modalViewPresentationStyle(.fullScreenCover)
            }
        }
    }
}

#endif

#endif
