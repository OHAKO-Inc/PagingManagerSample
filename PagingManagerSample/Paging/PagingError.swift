//
//  PagingError.swift
//  PagingManagerSample
//
//  Created by Yoshikuni Kato on 2017/12/15.
//  Copyright © 2017 張穎. All rights reserved.
//

import Foundation

enum PagingError<ServiceError: Error>: Error {
    case service(ServiceError)

    var serviceError: ServiceError {
        switch self {
        case .service(let error):
            return error
        }
    }
}
