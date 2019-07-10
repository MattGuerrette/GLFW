//
//  Window.swift
//  
//
//  Created by Matthew Guerrette on 7/9/19.
//

import cglfw


public class Window {
    
    private var window : OpaquePointer?
    
    /// Flag for determining if window should be closing
    public var shouldClose : Bool {
        get {
            guard window != nil else {
                fatalError("Window uninitialized")
            }
            
            return glfwWindowShouldClose(window) == GLFW_TRUE
        }
    }
    
    /// Shows the window
    public func show() {
        glfwShowWindow(window)
    }
    
    /// Hides the window
    public func hide() {
        glfwHideWindow(window)
    }
    
    /// Initializes a window
    public init() {
        window = glfwCreateWindow(800, 600, "Bob", nil, nil)
    }
    
    deinit {
        glfwDestroyWindow(window)
    }
    
    // Window Attributes
    
    public var focused : Bool {
        get {
            return glfwGetWindowAttrib(window, WindowAttribute.focused.rawValue) == GLFW_TRUE
        }
        set {
            glfwSetWindowAttrib(window, GLFW_FOCUSED, newValue.glfwBool())
        }
    }
}

public enum WindowAttribute: Int32 {
    public typealias RawValue = Int32
    
    case focused = 0x00020001
    case iconified = 0x00020002
    case resizable = 0x00020003
    case visible = 0x00020004
    case decorated = 0x00020005
    case autoIconify = 0x00020006
    case floating = 0x00020007
    case maximized = 0x00020008
    case transparentFramebuffer = 0x0002000A
    case hovered = 0x0002000B
    case focusOnShow = 0x0002000C
}
