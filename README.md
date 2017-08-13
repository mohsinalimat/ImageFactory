
<p align="center">
  <!-- <img src="" alt="EnumCollection"> -->
  <br/><a href="https://cocoapods.org/pods/ImageFactory">
  <img alt="Version" src="https://img.shields.io/badge/version-1.0.0-brightgreen.svg">
  <img alt="Author" src="https://img.shields.io/badge/author-Meniny-blue.svg">
  <img alt="Build Passing" src="https://img.shields.io/badge/build-passing-brightgreen.svg">
  <img alt="Swift" src="https://img.shields.io/badge/swift-3.0%2B-orange.svg">
  <br/>
  <img alt="Platforms" src="https://img.shields.io/badge/platform-iOS-lightgrey.svg">
  <img alt="MIT" src="https://img.shields.io/badge/license-MIT-blue.svg">
  <br/>
  <img alt="Cocoapods" src="https://img.shields.io/badge/cocoapods-compatible-brightgreen.svg">
  <img alt="Carthage" src="https://img.shields.io/badge/carthage-working%20on-red.svg">
  <img alt="SPM" src="https://img.shields.io/badge/swift%20package%20manager-working%20on-red.svg">
  </a>
</p>

# Introduction

## What's this?

`ImageFactory` is an easy way to make UIImage objects.

## Requirements

* iOS 8.0+
* Xcode 8 with Swift 3

## Installation

#### CocoaPods

```ruby
pod 'ImageFactory'
```

## Contribution

You are welcome to fork and submit pull requests.

## License

`ImageFactory` is open-sourced software, licensed under the `MIT` license.

## Usage

```swift
public func += (lhs: inout [ImageFactory], rhs: ImageFactory) {
    lhs.append(rhs)
}
```

```swift
import ImageFactory
```

```swift
var factoryArray: [ImageFactory] = []
let sizeType = CGSizeType.fixed(CGSize(width: 100, height: 100))

factoryArray += ImageFactory(fillColor: .brown)
factoryArray += ImageFactory(fillGradient: [.red, .green])

factoryArray += ImageFactory(borderColor: .red, width: 10, size: sizeType)
factoryArray += ImageFactory(border: .yellow, width: 10, background: .green, size: sizeType)
factoryArray += ImageFactory(borderGradient: [.green, .yellow, .red], width: 10, size: sizeType)
factoryArray += ImageFactory(border: .red, width: 10, alignment: .inside, background: .purple, size: sizeType, cornerRadius: CGCornerRadius(.all, radius: 15))

let image = factoryArray.first!.image
// UIImage?
```
