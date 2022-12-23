//
//  GuardiansList.swift
//  DisApp
//
//  Created by Dmitry Bespalov on 22.12.22.
//

import Foundation

class ResID: Hashable {
    static func == (lhs: ResID, rhs: ResID) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }

    func hash(into hasher: inout Hasher) {
        ObjectIdentifier(self).hash(into: &hasher)
    }
}

class GuardiansListID: ResID {

}

struct GuardiansList: Codable {
    var items: [Guardian]
}

struct Guardian: Codable {
    var name: String
    var address: String
    var ens: String?
    var image: String
    var reason: String
    var contribution: String
}

extension GuardiansList {
    init(from decoder: Decoder) throws {
        items = try [Guardian](from: decoder)
    }

    func encode(to encoder: Encoder) throws {
        try items.encode(to: encoder)
    }
}
