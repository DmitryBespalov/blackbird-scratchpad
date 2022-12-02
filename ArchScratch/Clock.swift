//
//  Clock.swift
//  ArchScratch
//
//  Created by Dmitry Bespalov on 02.12.22.
//

import Foundation

class Clock {
    func now() -> TimeInterval {
        Date().timeIntervalSince1970
    }
}
