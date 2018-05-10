//: [Previous](@previous)
/*:
 # ContainerViewShowing
 */
import UIKit
import XCPlayground
import PlaygroundSupport
import Prelude

class ParentViewController: UIViewController, ContainerViewShowing {

    let containerView = UIView(frame: CGRect(x: 50, y: 50, width: 275, height: 567))
    let childViewController = ChildViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(containerView)
    }

    func addSampleChildViewController() {
        addChildViewController(childViewController, to: containerView)
    }

    func removeSampleChildViewController() {
        removeChildViewController(childViewController)
    }
}

class ChildViewController: UIViewController {

    lazy var label: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 275, height: 567))
        label.textAlignment = .center
        label.textColor = .white
        label.text = "Child View Controller"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        view.addSubview(label)
    }
}

let parentViewController = ParentViewController()
PlaygroundPage.current.liveView = parentViewController

// add
parentViewController.addSampleChildViewController()

// remove
//parentViewController.removeSampleChildViewController()

//: [Next](@next)
