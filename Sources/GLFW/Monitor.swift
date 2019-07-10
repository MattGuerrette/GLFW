//
//  File.swift
//  
//
//  Created by Matthew Guerrette on 7/10/19.
//

import Foundation
import cglfw

public class Monitor {
    
    private var monitor : OpaquePointer?
    
    public var name : String {
        get {
            guard monitor != nil else {
                fatalError("Monitor not initialized")
            }
            
            return String.init(cString: glfwGetMonitorName(monitor))
        }
    }
    
    public static var primary : Monitor = {
       return Monitor(glfwGetPrimaryMonitor())
    }()
    
    init(_ monitor: OpaquePointer?) {
        self.monitor = monitor
    }
}
