//
//  Window.swift
//  
//
//  Created by Matthew Guerrette on 7/9/19.
//

import cglfw


public class Window {
    
    private var opaque : OpaquePointer?

    public var cursor : Cursor? {
        didSet {
            glfwSetCursor(opaque, cursor!.opaque)
        }
    }
    
    /// Flag for determining if window should be closing
    public var shouldClose : Bool {
        get {
            guard opaque != nil else {
                fatalError("Window uninitialized")
            }
            
            return glfwWindowShouldClose(opaque) == GLFW_TRUE
        }
    }
    
    /// Shows the window
    public func show() {
        glfwShowWindow(opaque)
    }
    
    /// Hides the window
    public func hide() {
        glfwHideWindow(opaque)
    }
    
    /// Initializes a window
    public init() {
        opaque = glfwCreateWindow(800, 600, "Bob", nil, nil)
    }
    
    deinit {
        glfwDestroyWindow(opaque)
    }
    
    // Window Attributes

    
    public var focused : Bool {
        get {
            return glfwGetWindowAttrib(opaque, WindowAttribute.focused.rawValue) == GLFW_TRUE
        }
        set {
            glfwSetWindowAttrib(opaque, GLFW_FOCUSED, newValue.glfwBool())
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
