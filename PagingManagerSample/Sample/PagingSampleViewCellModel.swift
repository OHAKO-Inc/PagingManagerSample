//
//  PagingSampleViewCellModel.swift
//  PagingManager
//
//  Created by 張穎 on 2017/09/13.
//  Copyright © 2017年 張穎. All rights reserved.
//

import Foundation

protocol PagingSampleViewCellModeling {
    var numString: String { get }
}

struct PagingSampleViewCellModel: PagingSampleViewCellModeling {
    let numString: String
}
