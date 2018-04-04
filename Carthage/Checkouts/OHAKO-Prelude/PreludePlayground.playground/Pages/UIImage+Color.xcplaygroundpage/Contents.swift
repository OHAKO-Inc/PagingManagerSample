//: [Previous](@previous)
/*:
 # UIImage+Color
 */
import UIKit
import XCPlayground
import PlaygroundSupport
import Prelude

let viewController = UIViewController()
viewController.view.backgroundColor = .white
PlaygroundPage.current.liveView = viewController

/*:
 ## makeImage(of color: UIColor) -> UIImage?
 */

let image = UIImage.makeImage(of: .gray)
let imageView = UIImageView(
    frame: CGRect(
        x: 100,
        y: 100,
        width: 100,
        height: 100
    )
)
imageView.image = image

viewController.view.addSubview(imageView)
