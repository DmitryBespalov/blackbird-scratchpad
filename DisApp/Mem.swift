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

    var subs: [ResID: [Pub]] = [:]

    func sub(_ id: ResID, _ pub: Pub) {
        // FIXME: duplicate subscriptions
        var pubs = subs[id] ?? []
        pubs.append(pub)
        subs[id] = pubs
    }

    func unsub(_ pub: Pub) {
        for id in subs.keys {
            var pubs = subs[id]
            pubs?.removeAll(where: { $0 === pub })
            subs[id] = pubs
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
        
        for pub in subs[id] ?? [] {
            pub.update(id)
        }
    }

}
enum MemErr: Error {
    case loading
    case netInvalidResponse
    case netErr(code: Int, data: Data?)
    case netDecoding(err: Error, data: Data)
}

protocol Pub: AnyObject {
    func update(_ id: ResID)
}
