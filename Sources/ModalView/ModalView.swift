//
//  ModalView.swift
//  ModalView
//
//  Created by Denis Chaschin on 22.09.2019.
//  Copyright © 2019 Denis Chaschin. All rights reserved.
//

import SwiftUI

private final class Pipe : ObservableObject {
    struct Content: Identifiable {
        fileprivate typealias ID = String
        fileprivate let id = UUID().uuidString
        var view: AnyView
    }
    @Published var content: Content? = nil
}

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

struct ModalLink<Label, Destination> : View where Label : View, Destination : View  {
    @EnvironmentObject private var modalView: Pipe
    
    private var destination: AnyView
    private var label: Label
    
    init(destination: Destination, @ViewBuilder label: () -> Label) {
        self.destination = AnyView(destination)
        self.label = label()
    }
    
    var body: some View {
        Button(action: presentModalView){ label }
    }
    
    private func presentModalView() {
        modalView.content = Pipe.Content(view: destination)
    }
}

#if DEBUG

struct ModalLink_Preview: PreviewProvider {
    
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
