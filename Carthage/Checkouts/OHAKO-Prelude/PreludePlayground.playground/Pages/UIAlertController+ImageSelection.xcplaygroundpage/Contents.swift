//: [Previous](@previous)
/*:
 ## showImageSelectAlertController(container: UIViewController, imagePicker: UIImagePickerController)
 */
import UIKit
import XCPlayground
import PlaygroundSupport
import Prelude

class ViewController: UIViewController {

    lazy var button: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
        button.setTitle("ImageSelection", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(button)
        button.addTarget(self, action: #selector(ViewController.imageSelectionButtonTapped(_:)), for: .touchUpInside)
    }

    @objc func imageSelectionButtonTapped(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        UIAlertController.showImageSelectAlertController(container: self, imagePicker: imagePicker)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        guard info[UIImagePickerControllerEditedImage] != nil else {
            return
        }
        // use image
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

let viewController = ViewController()
PlaygroundPage.current.liveView = viewController

//: [Next](@next)
