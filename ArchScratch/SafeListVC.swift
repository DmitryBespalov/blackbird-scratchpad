//
//  SafeListVC.swift
//  ArchScratch
//
//  Created by Dmitry Bespalov on 02.12.22.
//

import UIKit

class SafeListVC: UITableViewController, Receiver {

    // model id
    var id: SafeListID!

    // model
    var list: SafeList?

    func update() {
        let list = SafeList.get(id)
        precondition(list.state == .ok, "Expected list always exist")
        self.list = list
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let list = list else { return 0 }
        return list.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let list = list, indexPath.row < list.items.count else { return .init() }
        let item = list.items[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "SafeCell", for: indexPath)

            var content = cell.defaultContentConfiguration()
            content.text = item.value

        cell.contentConfiguration = content
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // construct 'add' button
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        navigationItem.rightBarButtonItem = addButton

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SafeCell")

        update()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Medium.subscribe(self, for: id)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Medium.remove(self)
    }

    func notify(_ id: SafeListID) {
        // TODO: queueing / invalidation
        update()
    }

    @objc func add() {
        guard let list = list else { return }
        let item = SafeID(value: "/safe/1/0x2D5f98367ff3fD7C7DbE39933C60868030DAAC53")
        list.create(item)
        SafeList.update(list)
    }

}

struct SafeListID: Hashable {
    private var value: String

    init(value: String) {
        self.value = value
    }
}

enum ObjectState {
    case ok, none, error, deleted
}

class SafeList {
    private(set) var id: SafeListID
    private(set) var items: [SafeID]
    private(set) var state: ObjectState

    init(id: SafeListID, items: [SafeID], state: ObjectState) {
        self.id = id
        self.items = items
        self.state = state
    }

    func create(_ item: SafeID) {
        items.append(item)
    }

    class func get(_ id: SafeListID) -> SafeList {
        let item = Memory.get(id)
        return item
    }

    class func update(_ list: SafeList) {
        Memory.update(list)
    }
}

struct SafeID: Hashable {
    private (set) var value: String

    init(value: String) {
        self.value = value
    }
}

class Memory {
    static let shared = Memory()

    var dict: [AnyHashable: Any]

    init() {
        dict = [
            SafeListID(value: "/safes/global"): SafeList(id: SafeListID(value: "/safes/global"), items: [SafeID(value: "/safe/1/0x220866B1A2219f40e72f5c628B65D54268cA3A9D")], state: .ok)
            ]
    }

    class func get(_ id: SafeListID) -> SafeList {
        if let found = shared.dict[id] as? SafeList {
            return found
        } else {
            let notFound = SafeList(id: id, items: [], state: .none)
            return notFound
        }
    }

    class func update(_ item: SafeList) {
        shared.dict[item.id] = item
        Medium.notify(item.id)
    }
}

class Medium {
    static let shared = Medium()

    var listing: [SafeListID: [Receiver]] = [:]

    class func notify(_ id: SafeListID) {
        guard let list = shared.listing[id] else { return }
        for receiver in list {
            receiver.notify(id)
        }
    }

    class func subscribe(_ receiver: Receiver, for id: SafeListID) {
        var list = shared.listing[id] ?? []

        let isAlreadySubscribed = list.contains(where: { $0 === receiver })
        if isAlreadySubscribed {
            return
        }

        list.append(receiver)
        shared.listing[id] = list
    }

    class func remove(_ receiver: Receiver) {
        for id in shared.listing.keys {
            var list = shared.listing[id]!
            list.removeAll(where: { $0 === receiver })
            shared.listing[id] = list
        }
    }
}

protocol Receiver: AnyObject {
    func notify(_ id: SafeListID)
}
