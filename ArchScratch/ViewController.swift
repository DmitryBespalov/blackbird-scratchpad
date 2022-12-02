//
//  ViewController.swift
//  ArchScratch
//
//  Created by Dmitry Bespalov on 02.12.22.
//

import UIKit

class ViewController: UIViewController {

    var id: SafeID!
    var store: Store!

    override func viewDidLoad() {
        super.viewDidLoad()
        // subscribe for receiving safe change events
        // invalidate the view (reload)
    }

    deinit {
        // unsubscribe from receiving events
    }

    // on receiving event: enqueue it, invalidate the view.

    // on reloading (invalidation) of view:
        // dequeue and de-duplicate event(s)
        // query (pull) data from safe model
        // load data into display view

    func reload() {
        let result = store.get(id)
        switch result {
        case .some(let record) where record.state == .exists: // <- this hints that 'not found' should be a state, too.
            // display the values
            break

        case .none:
            // display not found state
            break

        case .some(let record) where record.state == .loading:
            // display loading state
            break

        case .some(let record) where record.state == .deleted:
            // display deleted state
            break

        case .some(let record) where record.state == .error:
            // display error state
            break

        default:
            // no-op
            break
        }
    }

}

// view must have a queue for enqueuing notification messages and then processing them.
