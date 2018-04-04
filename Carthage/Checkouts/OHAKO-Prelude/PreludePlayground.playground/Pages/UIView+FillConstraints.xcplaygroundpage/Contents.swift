//: [Previous](@previous)
/*:
 # UIView+FillConstraints
 */
import UIKit
import XCPlayground
import PlaygroundSupport
import Prelude

let viewController = UIViewController()
viewController.view.backgroundColor = .white
PlaygroundPage.current.liveView = viewController

/*:
 ## addFilledSubview(_ view: UIView)
 */
let underView01 = UIView(
    frame: CGRect(
        x: 100,
        y: 100,
        width: 100,
        height: 100
    )
)
underView01.backgroundColor = .yellow
viewController.view.addSubview(underView01)

let noneFrameView01 = UIView()
noneFrameView01.backgroundColor = .blue
underView01.addFilledSubview(noneFrameView01)

/*:
 ## insertFilledSubview(_ view: UIView, belowSubview siblingSubview: UIView)
 */

let noneFrameView02 = UIView()
noneFrameView02.backgroundColor = .red
let noneFrameView03 = UIView()
noneFrameView02.backgroundColor = .green

underView01.insertFilledSubview(noneFrameView02, belowSubview: noneFrameView03)

//: [Next](@next)
