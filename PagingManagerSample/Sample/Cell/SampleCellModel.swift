//
//  SampleCellModel.swift
//  PagingManager
//
//  Created by 張穎 on 2017/09/13.
//  Copyright © 2017年 張穎. All rights reserved.
//

import Foundation

protocol SampleCellModeling {
    var title: String { get }
}

struct SampleCellModel: SampleCellModeling {
    let title: String
}
