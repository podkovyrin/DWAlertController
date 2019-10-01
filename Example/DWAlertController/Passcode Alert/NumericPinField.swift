//
//  Created by Andrew Podkovyrin
//  Copyright © 2019 Andrew Podkovyrin. All rights reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  https://opensource.org/licenses/MIT
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit

protocol NumericPinFieldDelegate: AnyObject {
    func numericPinFieldDidFinishInput(_ pinField: NumericPinField)
}

enum PinOption: UInt8 {
    case fourDigits = 4
    case sixDigits = 6
}

class NumericPinField: UIView {
    var text: String {
        return value.joined()
    }

    var option = PinOption.fourDigits {
        didSet {
            clear()

            switch option {
            case .fourDigits:
                dotLayers.first?.opacity = 0
                dotLayers.last?.opacity = 0
            case .sixDigits:
                dotLayers.first?.opacity = 1
                dotLayers.last?.opacity = 1
            }
        }
    }

    var inputEnabled = true

    weak var delegate: NumericPinFieldDelegate?

    private var value = [String]()
    private let supportedCharacters = CharacterSet(charactersIn: "0123456789")
    private var dotLayers = [CAShapeLayer]()

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }

    override var intrinsicContentSize: CGSize {
        let count = CGFloat(PinOption.sixDigits.rawValue)
        let width = NumericPinField.dotSize * count + NumericPinField.paddingBetweenDots * (count - 1)
        return CGSize(width: width, height: NumericPinField.dotSize)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        dotLayers.forEach { dot in
            if #available(iOS 13.0, *) {
                dot.strokeColor = UIColor.label.cgColor
            } else {
                dot.strokeColor = UIColor.black.cgColor
            }
        }
        
        for index in 0..<value.count {
            var index = index
            if option == .fourDigits {
                index += 1
            }

            let dot = dotLayers[index]
            dot.fillColor = dot.strokeColor
        }
    }

    func clear() {
        value.removeAll()

        for dot in dotLayers.reversed() {
            dot.fillColor = UIColor.clear.cgColor
        }
    }

    func shake() {
        let shakeAnimation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        shakeAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        shakeAnimation.duration = 0.5
        shakeAnimation.values = [-24, 24, -16, 16, -8, 8, -4, 4, 0]
        layer.add(shakeAnimation, forKey: "shake-animation")
    }

    // MARK: UIResponder

    override var canBecomeFirstResponder: Bool {
        return true
    }

    override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        reloadInputViews()

        return result
    }

    // MARK: UITextInputTraits

    // declaring `keyboardType` as computed propery doesn't work
    var keyboardType = UIKeyboardType.numberPad

    // MARK: Private

    private func commonInit() {
        backgroundColor = .clear
        isUserInteractionEnabled = false
        
        // hide any assistant items on the iPad
        inputAssistantItem.leadingBarButtonGroups = []
        inputAssistantItem.trailingBarButtonGroups = []
        
        var x: CGFloat = 0
        for _ in 0 ..< PinOption.sixDigits.rawValue {
            let dot = NumericPinField.dotLayer()
            dot.frame = CGRect(x: x, y: 0, width: NumericPinField.dotSize, height: NumericPinField.dotSize)
            layer.addSublayer(dot)
            dotLayers.append(dot)
            x += NumericPinField.dotSize + NumericPinField.paddingBetweenDots
        }
        
        option = .fourDigits
    }
    
    private func isInputStringValid(_ string: String?) -> Bool {
        guard let string = string else {
            return false
        }

        guard string.count == 1 else {
            return false
        }

        return string.first?.isWholeNumber ?? false
    }
}

extension NumericPinField: UIKeyInput {
    var hasText: Bool {
        return !value.isEmpty
    }

    func insertText(_ text: String) {
        guard inputEnabled else {
            return
        }

        guard isInputStringValid(text) else {
            return
        }

        if value.count >= option.rawValue {
            return
        }

        value.append(text)

        var index = value.count - 1
        if option == .fourDigits {
            index += 1
        }

        let dot = dotLayers[index]
        dot.fillColor = dot.strokeColor

        if value.count == option.rawValue {
            // after dot's animation
            let when = DispatchTime.now() + CATransaction.animationDuration()
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.delegate?.numericPinFieldDidFinishInput(self)
            }
        }
    }

    func deleteBackward() {
        guard inputEnabled else {
            return
        }

        let count = value.count
        // swiftlint:disable empty_count
        guard count > 0 else {
            return
        }
        // swiftlint:enable empty_count

        value.removeLast()

        var index = count - 1
        if option == .fourDigits {
            index += 1
        }
        
        let dot = dotLayers[index]
        dot.fillColor = UIColor.clear.cgColor
    }
}

extension NumericPinField: UITextInput {
    // Since we don't need to support cursor and selection implementation of UITextInput is a dummy

    // swiftlint:disable unused_setter_value

    func replace(_ range: UITextRange, withText text: String) {}

    var selectedTextRange: UITextRange? {
        get {
            return nil
        }
        set(selectedTextRange) {}
    }

    var markedTextRange: UITextRange? {
        return nil
    }

    var markedTextStyle: [NSAttributedString.Key: Any]? {
        get {
            return nil
        }
        set(markedTextStyle) {}
    }

    func setMarkedText(_ markedText: String?, selectedRange: NSRange) {}

    func unmarkText() {}

    var beginningOfDocument: UITextPosition {
        return UITextPosition()
    }

    var endOfDocument: UITextPosition {
        return UITextPosition()
    }

    func textRange(from fromPosition: UITextPosition, to toPosition: UITextPosition) -> UITextRange? {
        return nil
    }

    func position(from position: UITextPosition, offset: Int) -> UITextPosition? {
        return nil
    }

    func position(from position: UITextPosition, in direction: UITextLayoutDirection, offset: Int) -> UITextPosition? {
        return nil
    }

    func compare(_ position: UITextPosition, to other: UITextPosition) -> ComparisonResult {
        return .orderedSame
    }

    func offset(from: UITextPosition, to toPosition: UITextPosition) -> Int {
        return 0
    }

    var inputDelegate: UITextInputDelegate? {
        get {
            return nil
        }
        set(inputDelegate) {}
    }

    var tokenizer: UITextInputTokenizer {
        return UITextInputStringTokenizer(textInput: self)
    }

    func position(within range: UITextRange, farthestIn direction: UITextLayoutDirection) -> UITextPosition? {
        return nil
    }

    func characterRange(byExtending position: UITextPosition,
                        in direction: UITextLayoutDirection) -> UITextRange? {
        return nil
    }

    func baseWritingDirection(for position: UITextPosition,
                              in direction: UITextStorageDirection) -> UITextWritingDirection {
        return .natural
    }

    func setBaseWritingDirection(_ writingDirection: UITextWritingDirection, for range: UITextRange) {}

    func firstRect(for range: UITextRange) -> CGRect {
        return .zero
    }

    func caretRect(for position: UITextPosition) -> CGRect {
        return .zero
    }

    func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        return []
    }

    func closestPosition(to point: CGPoint) -> UITextPosition? {
        return nil
    }

    func closestPosition(to point: CGPoint, within range: UITextRange) -> UITextPosition? {
        return nil
    }

    func characterRange(at point: CGPoint) -> UITextRange? {
        return nil
    }

    func text(in range: UITextRange) -> String? {
        return nil
    }

    // swiftlint:enable unused_setter_value
}

private extension NumericPinField {
    static let dotSize: CGFloat = 12
    static let paddingBetweenDots: CGFloat = 24

    class func dotLayer() -> CAShapeLayer {
        let dot = CAShapeLayer()
        if #available(iOS 13.0, *) {
            dot.strokeColor = UIColor.label.cgColor
        } else {
            dot.strokeColor = UIColor.black.cgColor
        }
        dot.lineWidth = 1
        dot.fillColor = UIColor.clear.cgColor
        dot.fillRule = CAShapeLayerFillRule.evenOdd
        let rect = CGRect(x: 0, y: 0, width: dotSize, height: dotSize)
        let path = UIBezierPath(ovalIn: rect)
        dot.path = path.cgPath

        return dot
    }
}
