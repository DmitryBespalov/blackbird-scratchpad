//
//  Mem.swift
//  DisApp
//
//  Created by Dmitry Bespalov on 22.12.22.
//

import Foundation

class Mem {
    static let shared = Mem()

    private init() {}

    var subs: [ResID: [Sub]] = [:]

    func sub(_ id: ResID, _ s: Sub) {
        // FIXME: duplicate subscriptions
        var list = subs[id] ?? []
        list.append(s)
        subs[id] = list
    }

    func unsub(_ pub: Sub) {
        for id in subs.keys {
            var list = subs[id]
            list?.removeAll(where: { $0 === pub })
            subs[id] = list
        }
    }

    func get(_ id: ResID) -> Any {
        if let value = cache[id] {
            return value
        }

        Net.shared.get(id)

        return MemErr.loading
    }

    var cache: [ResID: Any] = [:]

    func update(_ id: ResID, _ value: Any) {
        cache[id] = value
        
        for s in subs[id] ?? [] {
            s.update(id)
        }
    }

}
enum MemErr: Error {
    case loading
    case netInvalidResponse
    case netErr(code: Int, data: Data?)
    case netDecoding(err: Error, data: Data)
}

protocol Sub: AnyObject {
    func update(_ id: ResID)
}
