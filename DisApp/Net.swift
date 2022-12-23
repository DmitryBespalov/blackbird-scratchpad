//
//  Net.swift
//  DisApp
//
//  Created by Dmitry Bespalov on 22.12.22.
//

import Foundation

// TODO: thread safety
// TODO: should it be on a queue?

class Net: NSObject, URLSessionDataDelegate {
    static let shared = Net()

    private override init() {
        queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.name = "net"
        super.init()
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        session = URLSession(configuration: config, delegate: self, delegateQueue: queue)
            // session -> delegate is strong reference until session is invalidated.
                // so, app leaks memory
            // but this class is a singleton and exists until the app exits.
            //
            // queue is used to serially schedule callbacks of requests.
    }

    func get(_ id: ResID) {
        commands.append(.init(verb: .get, id: id))
        queue.addOperation { [unowned self] in run() }
    }

    var commands: [NetCommand] = []

    let queue: OperationQueue

    var session: URLSession!

    func run() {
        let cmd = commands.removeFirst()
        // can transformation be dynamic / flexible?
        let baseURL = URL(string: "https://safe-claiming-app-data.gnosis-safe.io/")!
        let url = URL(string: "/guardians/guardians.json", relativeTo: baseURL)!
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request)
        commandsInProgress[task.taskIdentifier] = cmd
        task.resume()

    }

    var commandsInProgress: [Int: NetCommand] = [:]
    var receivedData: [Int: Data] = [:]

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        var ourData = receivedData[dataTask.taskIdentifier] ?? Data()
        ourData.append(data)
        receivedData[dataTask.taskIdentifier] = ourData
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        let cmd = commandsInProgress.removeValue(forKey: task.taskIdentifier)! // command must exist.
        let data = receivedData.removeValue(forKey: task.taskIdentifier)

        if let error = error {
            Mem.shared.update(cmd.id, error)
            return
        }

        guard let resp = task.response as? HTTPURLResponse else {
            Mem.shared.update(cmd.id, MemErr.netInvalidResponse)
            return
        }

        if 200 <= resp.statusCode && resp.statusCode <= 299 {
            let requiredData = data!
            do {
                let decoder = JSONDecoder()
                let value = try decoder.decode(GuardiansList.self, from: requiredData)
                Mem.shared.update(cmd.id, value)
            } catch {
                Mem.shared.update(cmd.id, MemErr.netDecoding(err: error, data: requiredData))
                return
            }
        } else {
            Mem.shared.update(cmd.id, MemErr.netErr(code: resp.statusCode, data: data))
        }
    }
}

struct NetCommand {
    enum Verb {
        case get
    }

    var verb: Verb
    var id: ResID
}
