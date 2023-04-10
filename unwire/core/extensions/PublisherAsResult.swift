//
//  PublisherAsResult.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

import Combine

extension Publisher {
    func asResult() -> AnyPublisher<Result<Output, Failure>, Never> {
        self
            .map { .success($0) }
            .catch { err in Result.Publisher(.failure(err))}
            .eraseToAnyPublisher()
    }
}
