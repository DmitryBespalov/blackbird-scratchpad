//
//  ViewController.swift
//  ArchScratch
//
//  Created by Dmitry Bespalov on 02.12.22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

// ----

// Data Schema:

// Any Object
    // ID       object_id
    // status   enum // none | ok | error | deleted
    // updated  timestamp
    // hash     data (?)


// Safe List - user's collection of safes |ID /safes/{id}
    // id       string   // id of the list: global
    // items    safe_id[]

// Safe |ID /safe/{chain_id}/{address}
    // chain_id     int     // id{1}
    // address      address // id{2}
    // owners       address[]
    // threshold    int
    // nonce        int // executed transaction count
    // modules      address[]
    // fallback     address
    // guard        address
    // impl         address // on the same chain
    // version      string // semantic version string of the implementation

// Safe Address Registry |ID /known-addresses
    // Record |ID /record/{chain_id}/{address}
        // chain_id     int     // id{1}
        // address      address // id{2}
        // name         string
        // logo         string // uri

// Chain Registry |ID /chains
    // Chain |ID /chain/{id}
        // id       int // id
        // short    string // short name
        // name     string // long name

// -----

// UI System Message Flow:
// Medium[Q] <-> View <-> Model <----------> Memory <-> [Q] Storage
//   ↑                      |                  ↑ |
//   |                      └─> [Q] Backend ---┘ |
//   └---<--------------<-----------------<------┘
//
//  Clock | Hasher

// Memory/Cache
    // singleton
    // get by id
    // update by id
    // delete by id

// Backend
    // singleton
    // exec command

// Medium
    // singleton
    // subscribe
    // unsubscribe
    // notify
    // handle

// Storage
    // singleton
    // get
    // update
    // delete
