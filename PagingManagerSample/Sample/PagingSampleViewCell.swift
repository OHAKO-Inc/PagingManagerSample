//
//  PagingSampleViewCell.swift
//  PagingManager
//
//  Created by 張穎 on 2017/09/13.
//  Copyright © 2017年 張穎. All rights reserved.
//

import UIKit

class PagingSampleViewCell: UITableViewCell {
    // MARK: - Properties
    private var cellModel: PagingSampleViewCellModeling?

    // MARK: - View Elements
    @IBOutlet weak var numLabel: UILabel!

    func configure(with cellModel: PagingSampleViewCellModeling) {
        self.cellModel = cellModel
        numLabel.text = cellModel.numString

    }
}
