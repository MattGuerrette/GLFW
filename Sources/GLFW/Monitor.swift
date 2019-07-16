//
//  File.swift
//  
//
//  Created by Matthew Guerrette on 7/10/19.
//

import Foundation
import cglfw

public struct VideoMode {
    public let width : Int
    public let height : Int
    public let redBits : Int
    public let greenBits : Int
    public let blueBits : Int
    public let refreshRate : Int

    init(_ mode : GLFWvidmode) {
        self.width = Int(mode.width)
        self.height = Int(mode.height)
        self.redBits = Int(mode.redBits)
        self.greenBits = Int(mode.greenBits)
        self.blueBits = Int(mode.blueBits)
        self.refreshRate = Int(mode.refreshRate)
    }
}

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

    public var videoModes : [VideoMode] {
        get {
            var modes = [VideoMode]()

            var count : Int32 = 0
            let _modes = glfwGetVideoModes(opaque, &count)
            for mode in UnsafeBufferPointer<GLFWvidmode>(start: _modes, count: Int(count)) {
                modes.append(VideoMode.init(mode))
            }

            return modes
        }
    }

    public var contentScaleX : Float {
        get {
            var xScale : Float = 0.0
            glfwGetMonitorContentScale(opaque, &xScale, nil)

            return xScale
        }
    }

    public var contentScaleY : Float {
        get {
            var yScale : Float = 0.0
            glfwGetMonitorContentScale(opaque, nil, &yScale)

            return yScale
        }
    }

    public var videoMode : VideoMode? {
        get {
            guard let mode = glfwGetVideoMode(opaque) else {
                return nil
            }

            return VideoMode.init(mode.pointee)
        }
    }
    
    public static var primary : Monitor = {
       return Monitor(glfwGetPrimaryMonitor())
    }()
    
    init(_ opaque: OpaquePointer?) {
        self.opaque = opaque
    }
}
