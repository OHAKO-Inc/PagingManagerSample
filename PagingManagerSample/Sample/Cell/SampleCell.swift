//
//  SampleCell.swift
//  PagingManager
//
//  Created by 張穎 on 2017/09/13.
//  Copyright © 2017年 張穎. All rights reserved.
//

import UIKit

final class SampleCell: UITableViewCell {

    // MARK: - Properties
    private var cellModel: SampleCellModeling?

    // MARK: - View Elements
    @IBOutlet weak var titleLabel: UILabel!

    func configure(with cellModel: SampleCellModeling) {
        self.cellModel = cellModel
        titleLabel.text = cellModel.title
    }
}
