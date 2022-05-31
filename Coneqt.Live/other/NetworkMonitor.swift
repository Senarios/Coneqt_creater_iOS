//
//  NetworkMonitor.swift
//  Coneqt.Live
//
//  Created by Zain Ahmed on 03/12/2021.
//

import Foundation
import Network

final class NetworkMonitor{
    
    static let shared = NetworkMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    private let monitor : NWPathMonitor
    
    // make public anybody can access value but its setter ir private only this call set its value
    public private(set) var isConnected : Bool = false
    
    public private(set) var connectionType : ConnectionType?
    
    enum ConnectionType{
        
        case wifi
        case cellular
        case ethernet
    }
    
    private init(){
        self.monitor = NWPathMonitor()
        
    }
    
    public func startMonitoring(){
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = {[weak self] path in
            self?.isConnected = path.status == .satisfied
            self?.getConnectionType(path)
            
            
        }
    }
    
    public func stopMonitoring(){
        monitor.cancel()
    }
    
    private func getConnectionType(_ path : NWPath){
        
        if path.usesInterfaceType(.wifi){
            connectionType = .wifi
        }
        else if path.usesInterfaceType(.cellular){
            connectionType = .cellular
        }
        else if path.usesInterfaceType(.wiredEthernet){
            connectionType = .ethernet
        }
        else{
            connectionType = nil
        }
    }
 
}
