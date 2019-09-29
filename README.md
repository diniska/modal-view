# ModalView

![Swift 5.1](https://img.shields.io/badge/Swift-5.1-FA5B2C) ![Xcode 11](https://img.shields.io/badge/Xcode-11-44B3F6) ![iOS 13.0](https://img.shields.io/badge/iOS-13.0-178DF6) ![iPadOS 13.0](https://img.shields.io/badge/iPadOS-13.0-178DF6) ![MacOS 10.15](https://img.shields.io/badge/MacOS-10.15-178DF6)

SwiftUI An analogue of `NavigationView` that provides a convenient interface of displaying modal views.

## How to use
### Step 1
Add a dependency using Swift Package Manager to your project: [https://github.com/diniska/modal-view](https://github.com/diniska/modal-view)

#### Step 2
Import the dependency

```swift
import ModalView
```

### Step 3
Use `ModalPresenter` and `ModalLink` the same way you would use `NavigationView` and `NavigationLink`:

```swift
struct ContentView: View {
    var body: some View {
        ModalPresenter {
            ModalLink(destination: Text("Modal View")) {
                Text("Main view")
            }
        }
    }
}
```

### Result
![Presenting modal view with SwiftUI](./Docs/Resources/displaying-modal-view.gif)


## Additional information
To add a "close" button to a modal view we can use a `dismiss` closure provided by the `ModalLink`:

```swift
struct ContentView: View {
    var body: some View {
        ModalPresenter {
            ModalLink(destination: { dismiss in
                Button(action: dismiss) {
                    Text("Dismiss")
                }
            }) {
                Text("Main view")
            }
        }
    }
}
```

Moving the destination in the code above to a separate structure is a recommended way here to refactor the code here as modal views regularly contains a bit more that just a text or button.

```swift
struct ContentView: View {
    var body: some View {
        ModalPresenter {
            ModalLink(destination: MyModalView.init(dismiss:)) {
                Text("Main view")
            }
        }
    }
}

struct MyModalView: View {
    var dismiss: () -> ()
    var body: some View {
        Button(action: dismiss) {
            Text("Dismiss")
        }
    }
}
```


Learn more here: [Display Modal View with SwiftUI](https://medium.com/@diniska/modal-view-in-swiftui-3f9faf910249)

