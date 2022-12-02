//
//  Record.swift
//  ArchScratch
//
//  Created by Dmitry Bespalov on 02.12.22.
//

import Foundation

class Record {
    internal init(id: ObjectID, state: ObjectState, data: Any, timestamp: TimeInterval) {
        self.id = id
        self.state = state
        self.data = data
        self.timestamp = timestamp
    }

    var id: ObjectID
    var state: ObjectState
    var data: Any
    var timestamp: TimeInterval
}

