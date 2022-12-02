//
//  Medium.swift
//  ArchScratch
//
//  Created by Dmitry Bespalov on 02.12.22.
//

import Foundation

class Medium {

    func subscribe() {
    }

    func unsubscribe() {
    }

    func notify(_ event: Event) {
    }
}

class Changed: Event {
    internal init(id: ObjectID) {
        self.id = id
    }

    var id: ObjectID
}
