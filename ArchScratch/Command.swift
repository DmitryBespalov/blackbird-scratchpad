//
//  Command.swift
//  ArchScratch
//
//  Created by Dmitry Bespalov on 02.12.22.
//

import Foundation

class Command {
    internal init(id: CommandID, params: Any) {
        self.id = id
        self.params = params
    }

    var id: CommandID
    var params: Any
}

enum CommandID {
    case create, update, delete, get
}
