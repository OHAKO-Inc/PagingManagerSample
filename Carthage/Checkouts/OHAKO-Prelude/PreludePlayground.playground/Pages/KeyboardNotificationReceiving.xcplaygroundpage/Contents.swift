//: [Previous](@previous)
/*:
 # KeyboardNotificationReceiving
 */
import UIKit
import XCPlayground
import PlaygroundSupport
import Prelude

let textFieldOriginalFrame = CGRect(x: 0.0, y: 667.0 - 50.0, width: 375.0, height: 50.0)

class ViewController: UIViewController {

    lazy var textField: UITextField = {
        let textField = UITextField(frame: textFieldOriginalFrame)
        textField.borderStyle = .line
        textField.placeholder = "Text Field"
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(textField)
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(ViewController.viewTapped)
        )
        view.addGestureRecognizer(tapGesture)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ViewController.keyboardWillShow(_:)),
            name: .UIKeyboardWillShow,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ViewController.keyboardWillHide(_:)),
            name: .UIKeyboardWillHide,
            object: nil
        )
    }

    @objc func viewTapped() {
        view.endEditing(true)
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        handleKeyboardWillShow(notification)
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        handleKeyboardWillHide(notification)
    }
}

extension ViewController: KeyboardNotificationReceiving {
    func animationsWhenKeyboardWillMove(keyboardRect: CGRect, show: Bool) {
        // add custom animation here
        textField.frame = CGRect(
            x: textFieldOriginalFrame.origin.x,
            y: textFieldOriginalFrame.origin.y - (show ? keyboardRect.size.height : 0),
            width: textFieldOriginalFrame.size.width,
            height: textFieldOriginalFrame.size.height
        )
    }
}

let viewController = ViewController()
PlaygroundPage.current.liveView = viewController

//: [Next](@next)
