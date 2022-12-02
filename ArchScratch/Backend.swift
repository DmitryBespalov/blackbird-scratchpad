//
//  Backend.swift
//  ArchScratch
//
//  Created by Dmitry Bespalov on 02.12.22.
//

import Foundation

class Backend {
    internal init(store: Store, clock: Clock) {
        self.store = store
        self.clock = clock
    }

    // circular reference
    var store: Store
    var clock: Clock

    func execute(_ cmd: Command) {
        // enqueue command
        // ...
        // got response
        let exists = Record(id: cmd.params as! ObjectID, state: .exists, data: Data(), timestamp: clock.now())
        store.update(exists)

        // if not found - should it be a state, too? otherwise it'll be an infinite loop.
    }

    // triggered somehow (how?)
    func work() {
        // dequeue command
        // transform to request
        // send request
            // callback response for request
            // transform to id
            // store response for id

    }
}
