//
//  File.swift
//  
//
//  Created by Matthew Guerrette on 7/10/19.
//

import Foundation
import cglfw

public class Monitor {
    
    let opaque : OpaquePointer?
    
    public var name : String {
        get {
            guard opaque != nil else {
                fatalError("Monitor not initialized")
            }
            
            return String.init(cString: glfwGetMonitorName(opaque))
        }
    }
    
    public static var primary : Monitor = {
       return Monitor(glfwGetPrimaryMonitor())
    }()
    
    init(_ opaque: OpaquePointer?) {
        self.opaque = opaque
    }
}
