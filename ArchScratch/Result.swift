//
//  Result.swift
//  ArchScratch
//
//  Created by Dmitry Bespalov on 02.12.22.
//

import Foundation

class Result {
    internal init(status: Status, data: Any? = nil, timestamp: TimeInterval) {
        self.status = status
        self.data = data
        self.timestamp = timestamp
    }

    var status: Status
    var data: Any?
    var timestamp: TimeInterval
}

enum Status {
    case ok, accepted, error
}

enum ErrorStatus: Swift.Error {
    case notFound, unavailable, timeout, error
}

// alternative: func get() throws -> Any? : throws = error, Any - OK, ? - accepted.
    // any - OK, ? - not found, error - accepted?
