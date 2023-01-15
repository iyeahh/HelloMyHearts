//
//  NetworkMonitor.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/29/24.
//

import Foundation
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let queue = DispatchQueue.global()
    private let monitor = NWPathMonitor()

    var isConnected = false

    private init(){ }

    func startMonitoring(){
        monitor.start(queue: queue)

        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            if path.status == .satisfied {
                isConnected = true
            } else {
                isConnected = false
            }
        }
    }

     func stopMonitoring(){
        monitor.cancel()
    }
}
