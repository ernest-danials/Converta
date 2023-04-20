//
//  NetworkConnectionManager.swift
//  Converta
//
//  Created by Ernest Dainals on 19/03/2023.
//

import Foundation
import Network

class NetworkConnectionManager: ObservableObject {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "NetworkConnectionManager")

    @Published var isConnected = true
    
    // Image depends the network status.
    var imageName: String {
        return isConnected ? "wifi" : "wifi.exclamationmark"
    }
    
    // Text depends on the network status.
    var connectionDescription: String {
        if isConnected {
            return "Internet connection looks good!"
        } else {
            return "It looks like you're offline."
        }
    }
    
    init() { startMonitoring() }
    
    // method working when you touch 'Check Status' button.
    func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
            
            if path.usesInterfaceType(.wifi) {
                print("Using wifi")
            } else if path.usesInterfaceType(.cellular) {
                print("Using cellular")
            }
        }
    }
    
    // method stop checking.
    func stopMonitoring() {
        monitor.cancel()
    }
}
