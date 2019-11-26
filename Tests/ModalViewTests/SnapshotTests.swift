//
//  SnapshotTests.swift
//  
//
//  Created by Denis Chaschin on 26.09.2019.
//

import AppKit
import Foundation
import SwiftUI
import XCTest

struct SnapshotTests {
    var recording = false
    
    mutating func check<V: View>(size: CGSize, name: String = #function, @ViewBuilder view: () -> V) {
        if recording {
            record(size: size, name: name, view: view)
            XCTFail("Test has been recorded. Don't forget to turn off the `recording`")
        } else {
            verify(size: size, name: name, view: view)
        }
    }
    
    mutating func record<V: View>(size: CGSize, name: String = #function, @ViewBuilder view: () -> V) {
        self[named: fileName(functionName: name)] = takeSnapshot(view: view, size: size)
    }
    
    func verify<V: View>(size: CGSize, name: String, @ViewBuilder view: () -> V) {
        let existing = self[named: fileName(functionName: name)]
        XCTAssertNotNil(existing)
        let representation = takeSnapshot(view: view, size: size)
        XCTAssertEqual(representation, existing!)
    }
    
    private subscript(named resourceName: String) -> Data? {
        get {
            let path = URL(fileURLWithPath: resourcesPath, isDirectory: true).appendingPathComponent(resourceName, isDirectory: false)
            return try? Data(contentsOf: path)
        }
        set {
            let path = URL(fileURLWithPath: resourcesPath, isDirectory: true).appendingPathComponent(resourceName, isDirectory: false)
            do {
                try FileManager.default.removeItem(at: path)
            } catch {}
            try! newValue?.write(to: path)
        }
    }
}

private var resourcesPath: String {
    NSString.path(withComponents: URL(fileURLWithPath: #file).pathComponents.dropLast().dropLast() + ["Resources"])
}

private func takeSnapshot<V: View>(@ViewBuilder view: () -> V, size: CGSize) -> Data {
    let view = NSHostingView(rootView: view())
    view.frame.size = size
    return NSImage(data: view.dataWithPDF(inside: view.bounds))!.tiffRepresentation!
}

private func fileName(functionName: String) -> String {
    var result = functionName.components(separatedBy: "(")[0]
    if result.hasPrefix("test") {
        result = result.components(separatedBy: "test")[1]
    }
    return [result, ".png"].joined()
}
