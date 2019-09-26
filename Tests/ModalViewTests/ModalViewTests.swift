import XCTest
import SwiftUI

@testable import ModalView

final class ModalViewTests: XCTestCase {

    var snapshotTests = SnapshotTests(recording: false)
    
    static var allTests = [
        ("testEmptyModalPresenter", testEmptyModalPresenter),
    ]
    
    func testEmptyModalPresenter() {
        snapshotTests.check(size: CGSize(width: 5, height: 5)) {
            ModalPresenter {
                EmptyView()
            }
        }
    }
    
    func testModalPresenterWithText() {
        snapshotTests.check(size: CGSize(width: 50, height: 50)) {
             ModalPresenter {
                 Text("hello")
             }
         }
    }
    
    func testModalPresenterWithLink() {
        snapshotTests.check(size: CGSize(width: 50, height: 50)) {
             ModalPresenter {
                ModalLink(destination: EmptyView()) {
                    Text("hello")
                }
             }
         }
    }
    
    func testLinkInsideList() {
        snapshotTests.check(size: CGSize(width: 85, height: 60)) {
             ModalPresenter {
                List {
                    ModalLink(destination: EmptyView()) {
                        Text("first")
                    }
                    ModalLink(destination: EmptyView()) {
                        Text("second")
                    }
                }
             }
         }
    }
    
}
