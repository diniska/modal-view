//
//  ModalView.swift
//  ModalView
//
//  Created by Denis Chaschin on 22.09.2019.
//  Copyright © 2019 Denis Chaschin. All rights reserved.
//

#if canImport(SwiftUI) && canImport(Combine)

import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
private final class Pipe : ObservableObject {
    struct Content: Identifiable {
        fileprivate typealias ID = String
        fileprivate let id = UUID().uuidString
        var view: AnyView
    }
    @Published var content: Content? = nil
}

// Container of a view that contains ModalLink in its hierarchy
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct ModalPresenter<Content> : View where Content : View {
    @ObservedObject private var modalView = Pipe()
    
    private var content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        content
            .environmentObject(modalView)
            .sheet(item: $modalView.content, content: { $0.view })
    }
}

// An interactable element that presentas a modal view
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct ModalLink<Label, Destination> : View where Label : View, Destination : View  {
    public typealias DestinationBuilder = (_ dismiss: @escaping() -> ()) -> Destination
    @EnvironmentObject private var modalView: Pipe
    
    private enum DestinationProvider {
        case view(AnyView)
        case builder(DestinationBuilder)
    }
    
    private var destinationProvider: DestinationProvider
    private var label: Label
    
    // Default initializer
    public init(destination: Destination, @ViewBuilder label: () -> Label) {
        self.destinationProvider = .view(AnyView(destination))
        self.label = label()
    }
    
    // Use this initializer when `dismiss` method is needed in the modal view
    public init(@ViewBuilder destination: @escaping DestinationBuilder, @ViewBuilder label: () -> Label) {
        self.destinationProvider = .builder(destination)
        self.label = label()
    }
    
    public var body: some View {
        Button(action: presentModalView){ label }
    }
    
    private func presentModalView() {
        modalView.content = Pipe.Content(view: {
            switch destinationProvider {
            case let .view(view):
                return view
            case let .builder(build):
                return AnyView(build { self.dismissModalView() })
            }
        }())
    }
    
    private func dismissModalView() {
        modalView.content = nil
    }
}

#if DEBUG

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
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
            }
        }
    }
}

#endif

#endif
