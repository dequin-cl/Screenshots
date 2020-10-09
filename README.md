# Screenshots

This library is build to take full screenshots from your App. It has UIView/UITableView/UIScrollView Extension to get really easy, smart and instant screenshot images.

Its based on [DHSmartScreenshot](https://github.com/davidman/DHSmartScreenshot), work by [davidman](https://github.com/davidman)

## Install
### Swift Package Manager
Screenshots is available through [Swift Package Manager](https://github.com/apple/swift-package-manager/).

#### Xcode

Select `File > Swift Packages > Add Package Dependency...`,  

Or add this package manually to the dependencies in your `Package.swift` file:

```swift
.package(url: "https://github.com/dequin-cl/Screenshots.git", from: "1.0.0")
```

## Usage

Inside the ViewController, given a local variable tableView, you just need to call the library provided variable **screenshot**

```swift
import Screenshots
⋮
let image = tableView.screenshot
```

## Licensing information
Screenshots is under the MIT License.

## Supported platforms and versions of Swift

Swift 5.2

Platforms Tested:

* iOS 11 and up.
* iPadOS.

## Contact information

* **twitter**: @dequin_cl
* **email**: dequin@hey.com