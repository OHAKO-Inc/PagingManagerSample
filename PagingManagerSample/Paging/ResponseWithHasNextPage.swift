//
//  ResponseWithHasNextPage.swift
//  PagingManagerSample
//
//  Created by Yoshikuni Kato on 2017/12/15.
//  Copyright © 2017 張穎. All rights reserved.
//

import Foundation

struct ResponseWithHasNextPage<Item> {
    let items: [Item]
    let hasNextPage: Bool
}
