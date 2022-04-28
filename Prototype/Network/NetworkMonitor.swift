//
//  NetworkMonitor.swift
//  Prototype
//
//  Created by Никита on 4/26/22.
//

import Foundation
import Network

final class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    public private(set) var isConnected: Bool = false
    
    public private(set) var connectionType: ConnectionType = .unknown
    
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
//            print("Path status: \(path.status)")
            self?.isConnected = path.status == .satisfied
//            print(path.status == .satisfied)
            self?.getConnectionType(path)
        }
    }
    
//    var isConnected: Bool {
//        guard let monitor = monitor else { return false }
//        return monitor.currentPath.status == .satisfied
//    }
    
    public func stopMonitoring() {
        monitor.cancel()
    }
    
    func getConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        }
        else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        }
        else if path.usesInterfaceType(.wiredEthernet ) {
            connectionType = .ethernet
        }
        else {
            connectionType = .unknown
        }
    }
}
