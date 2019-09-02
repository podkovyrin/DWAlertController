# DWAlertController

[![CI Status](https://img.shields.io/travis/podkovyrin/DWAlertController.svg?style=flat)](https://travis-ci.org/podkovyrin/DWAlertController)
[![Version](https://img.shields.io/cocoapods/v/DWAlertController.svg?style=flat)](https://cocoapods.org/pods/DWAlertController)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/DWAlertController.svg?style=flat)](https://cocoapods.org/pods/DWAlertController)
[![Platform](https://img.shields.io/cocoapods/p/DWAlertController.svg?style=flat)](https://cocoapods.org/pods/DWAlertController)

When was the last time you told your designer you couldn't customize UIAlertController? Now it is possible. Without using any private API.

DWAlertController is an UIAlertController that supports displaying any view controller instead of title and message.
DWAlertController fully copies the look and feel of UIAlertController and has the same API.

<p align="center">
<img src="https://github.com/podkovyrin/DWAlertController/raw/master/assets/DWAlertController_Screens.png?raw=true" alt="DWAlertController Screenshots">
</p>

This alert successfully used in production in our app [Dash Wallet](https://apps.apple.com/app/dash-wallet/id1206647026).

## Supported Features

- iPhone / iPad compatible
- Device rotations
- Keyboard support
- Customizable action buttons (normal / disabled / destructive tint colors)
- Custom presentation and dismissal transitions (corresponds to `UIAlertController` ones)
- Dimming tintColor-ed views behind the alert
- Simple built-in transition from one content controller to another within a single `DWAlertController` (see Advanced alert in the Example app)
- Dynamic Type
- Accessibility

## Usage

DWAlertController is written in Objective-C and optimized for Swift. All API that `DWAlertController` provides is the same as `UIAlertController`.

### Swift
```swift
let controller = ... // instantiate view controller

let alert = DWAlertController(contentController: controller)

let okAction = DWAlertAction(title: NSLocalizedString("OK", comment: ""),
                             style: .cancel,
                             handler: nil)
alert.addAction(okAction)

present(alert, animated: true)
```

### Objective-C
```obj-c
UIViewController *controller = ...; // instantiate view controller

DWAlertController *alert = [DWAlertController alertControllerWithContentController:controller];

DWAlertAction *okAction = [DWAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
                                                   style:DWAlertActionStyleCancel
                                                 handler:nil];
[alert addAction:okAction];

[self presentViewController:alert animated:YES completion:nil];
```

### Important notice

To make `DWAlertController` works with a custom content controller, the view of the content controller must correctly implement Autolayout.
You might have used the same technique when implementing dynamic-sized `UITableViewCell`'s.
For more information see https://stackoverflow.com/a/18746930

Since DWAlertController maintain scrolling of large content controllers internally (as UIAlertController does) there is no need in placing the content of content view controller within UIScrollView.

The `backgroundColor` of the content controller's view should be transparent (`UIColor.clear`).

## Limitations

- Only `UIAlertController.Style.alert` is supported (since there are a lot of decent implementations of actionSheet-styled controls)
- Updating the height of the currently displaying view controller is not supported. However, when displaying a new controller with `performTransition(toContentController:animated:)` method, it may have a different height.
- iOS 13 Dark Mode is not currently supported (WIP).

## Requirements

iOS 9 or later.

## Notes

The default `UIAlertController` achieves such vibrant and expressive background color by using the private CoreAnimation class `CABackdropLayer` which is lying within another private class `_UIDimmingKnockoutBackdropView` with `UIVisualEffectView`.
This layer uses a `CAFilter` with `"overlayBlendMode"` to apply the effect to the view behind it. To get more information refer this [answer](https://stackoverflow.com/a/49571448/2830525).

As we wanted to use this alert in production we couldn't use any of those APIs.
There are two possible options to get decent appearance comparable to using the private API.

1. Make a screenshot of a view behind the alert and apply `CIFilter` with `CIOverlayBlendMode` to it. This approach results in the closest appearance to `UIAlertController`. However, there are several reasons why this approach cannot be used. Screenshotting during presentation adds a noticeable lag, neither it can't be done after presentation which might have led to blinking the content behind the alert. It would also have to take a screenshot when the user rotates the screen wich also lead to lags.
2. Make a "hole" in the dimming view behind the alert and allow `UIVisualEffectView` to do all work. As a dimming view, we use `CAShapeLayer` with animatable `path` property to dynamically modify the "hole" during rotation or keyboard animation. While this is NOT a 100% smooth solution, it works almost perfectly and looks very close to `UIAlertController`.

All the colors and layout constants have been carefully copied from the `UIAlertController`.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation via CocoaPods

DWAlertController is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'DWAlertController'
```

## Installation via Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate DWAlertController into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "podkovyrin/DWAlertController"
```

## Author

Andrew Podkovyrin, podkovyrin@gmail.com

## License

DWAlertController is available under the MIT license. See the LICENSE file for more info.
