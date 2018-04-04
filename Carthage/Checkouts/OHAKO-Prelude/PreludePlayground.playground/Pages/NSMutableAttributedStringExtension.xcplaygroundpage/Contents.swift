//: [Previous](@previous)
/*:
 # NSMutableAttributedStringExtension
 */
import UIKit
import XCPlayground
import PlaygroundSupport
import Prelude

/*:
 ### target
 - init(text: String, font: UIFont, lineSpacing: CGFloat = 0.0)
 - boundingRectForUITextView(width: CGFloat) -> CGRect
 - boundingRectForUILabel(width: CGFloat) -> CGRect
 */

let viewController = UIViewController()
viewController.view.backgroundColor = .white
PlaygroundPage.current.liveView = viewController

let nsMutableAttributedString01 = NSMutableAttributedString(
    text: "foo\nbar\nfoo\nbar\nfoo\nbar\nfoo\nbar\nfoo\nbar",
    font: UIFont.boldSystemFont(ofSize: 20),
    lineSpacing: 2
)

let nsMutableAttributedStringLabel = UILabel(frame:
    CGRect(
        x: 0,
        y: 0,
        width: viewController.view.bounds.width,
        height: nsMutableAttributedString01.boundingRectForUILabel(width: viewController.view.bounds.width).height
    )
)
nsMutableAttributedStringLabel.numberOfLines = 0
nsMutableAttributedStringLabel.backgroundColor = .yellow
nsMutableAttributedStringLabel.attributedText = nsMutableAttributedString01
viewController.view.addSubview(nsMutableAttributedStringLabel)

let nsMutableAttributedString02 = NSMutableAttributedString(
    text: "hoge\nfuga\nhoge\nfuga\nhoge\nfuga\nhoge\nfuga\nhoge\nfuga",
    font: UIFont.boldSystemFont(ofSize: 20),
    lineSpacing: 10
)

let nsMutableAttributedStringTextView = UITextView(frame:
    CGRect(
        x: 0,
        y: nsMutableAttributedStringLabel.bounds.height,
        width: viewController.view.bounds.width,
        height: nsMutableAttributedString02.boundingRectForUITextView(width: viewController.view.bounds.width).height
    )
)
nsMutableAttributedStringTextView.backgroundColor = .cyan
nsMutableAttributedStringTextView.attributedText = nsMutableAttributedString02
viewController.view.addSubview(nsMutableAttributedStringTextView)

//: [Next](@next)
