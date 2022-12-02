//
//  Object.swift
//  ArchScratch
//
//  Created by Dmitry Bespalov on 02.12.22.
//

import Foundation

enum ObjectState {
    case absent
    case exists
    case deleted
    case loading
    case failed
}

class ObjectID: Hashable {
    static func == (lhs: ObjectID, rhs: ObjectID) -> Bool {
        lhs === rhs
    }

    func hash(into hasher: inout Hasher) {
        // ?
    }
}
