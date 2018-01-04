//
//  SignalProducer+resultWrapped.swift
//  PagingManagerSample
//
//  Created by Yoshikuni Kato on 2017/12/15.
//  Copyright © 2017 張穎. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

extension SignalProducer {
    func resultWrapped() -> SignalProducer<Result<Value, Error>, NoError> {
        return self
            .map { value -> Result<Value, Error> in
                return .success(value)
            }
            .flatMapError { error -> SignalProducer<Result<Value, Error>, NoError> in
                return .init(value: .failure(error))
        }
    }
}
