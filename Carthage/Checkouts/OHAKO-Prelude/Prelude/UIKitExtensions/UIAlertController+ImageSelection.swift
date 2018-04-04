//
//  UIAlertController+ImageSelection.swift
//  Prelude
//
//  Created by Yoshikuni Kato on 2016/10/21.
//  Copyright © 2016年 Ohako Inc. All rights reserved.
//

import UIKit

public extension UIAlertController {
    public class func showImageSelectAlertController(
        container: UIViewController,
        imagePicker: UIImagePickerController
    ) {

        let pickerAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            pickerAlert.addAction(UIAlertAction(title: "アルバムから選択", style: .default, handler: { (_) -> Void in
                imagePicker.sourceType = .photoLibrary
                container.present(imagePicker, animated: true, completion: nil)
            }))
        }

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            pickerAlert.addAction(UIAlertAction(title: "写真を撮る", style: .default, handler: { (_) -> Void in
                imagePicker.sourceType = .camera
                container.present(imagePicker, animated: true, completion: nil)
            }))
        }

        pickerAlert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        container.present(pickerAlert, animated: true, completion: nil)
    }
}
