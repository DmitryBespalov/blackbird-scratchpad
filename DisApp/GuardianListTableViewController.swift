//
//  GuardianListTableViewController.swift
//  DisApp
//
//  Created by Dmitry Bespalov on 23.12.22.
//

import UIKit

class GuardianListTableViewController: UITableViewController, Pub {
    let id = GuardiansListID.shared
    var list: GuardiansList?

    var queue: OperationQueue!

    override func viewDidLoad() {
        super.viewDidLoad()
        queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.name = "vc"
        queue.underlyingQueue = .main

        tableView.register(UINib(nibName: "GuardianTableViewCell", bundle: .main), forCellReuseIdentifier: "Guardian")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100

        Mem.shared.sub(id, self)

        update(id)
    }

    var notifs: [ResID] = []

    func update(_ id: ResID) {
        notifs.append(id)
        queue.addOperation { [unowned self] in
            reload()
        }
    }

    deinit {
        Mem.shared.unsub(self)
    }

    func reload() {
        let id = notifs.removeFirst()

        // get data
        let result = Mem.shared.get(id)

        // handle errors
        if let err = result as? MemErr {
            switch err {
            case .loading:
                print("loading...")
            case .netInvalidResponse:
                print("wrong response from server")
            case .netErr(code: let code, data: let data):
                print("server code: \(code)", String(data: data ?? Data(), encoding: .utf8) ?? "")

            case .netDecoding(err: let error, data: let data):
                print("server decoding error: \(error)", String(data: data, encoding: .utf8) ?? "")
            }
            return
        }

        // display the result
        list = (result as! GuardiansList)
        tableView.reloadData()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list?.items.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = list?.items[indexPath.row] else {
            return UITableViewCell()
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "Guardian", for: indexPath)
            as! GuardianTableViewCell
        cell.item = item
        return cell
    }

}
