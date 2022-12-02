//
//  Store.swift
//  ArchScratch
//
//  Created by Dmitry Bespalov on 02.12.22.
//

import Foundation

class Store {
    internal init(memory: Memory, backend: Backend, clock: Clock, medium: Medium) {
        self.memory = memory
        self.clock = clock
        self.backend = backend
        self.medium = medium
    }

    var memory: Memory
    var clock: Clock
    var backend: Backend
    var medium: Medium

    func get(_ id: ObjectID) -> Record? {
        if let found = memory.get(id) { // should query - that's the decision that this system makes.
            // this can depend on the object itself, not?
            // in the end, we're recording the result of our search process.
            // was it found previously? how long time ago? should we start searching again?
            return found
        } else {
            let loading = Record(id: id, state: .loading, data: NilData(), timestamp: clock.now())
            memory.update(loading)

            let get = Command(id: .get, params: id)
            backend.execute(get)

            return loading
        }
    }

    // maybe it makes sense to move some data from Result into Record
    func update(_ record: Record) {
        memory.update(record)

        // enqueue for persistence

        let changed = Changed(id: record.id)
        medium.notify(changed)
    }
}

typealias NilData = Data

class Memory {
    internal init(dict: [ObjectID : Record]) {
        self.dict = dict
    }

    var dict: [ObjectID: Record]

    func get(_ id: ObjectID) -> Record? {
        dict[id]
    }

    func update(_ record: Record) {
        dict[record.id] = record
    }
}
