//
//  networkMonitor.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/10/27.
//


import SwiftUI
import SystemConfiguration

final class networkMonitor : ObservableObject{
    
  
   
    //현재 네트워크 상태를 체크하는 코드
    func networkReachable(to flags : SCNetworkReachabilityFlags) -> Bool{
        
        let reachable = flags.contains(.reachable)
        let nConnection = flags.contains(.connectionRequired)
        let CConnectionAutomatically = flags.contains(.connectionOnDemand) && !flags.contains(.interventionRequired)
        
        
        return reachable &&  (!nConnection || CConnectionAutomatically)
    }
}


