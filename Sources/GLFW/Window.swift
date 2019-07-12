//
//  Window.swift
//  
//
//  Created by Matthew Guerrette on 7/9/19.
//

import cglfw


public class Window {
    
    var opaque : OpaquePointer?
    
    var keyCallback : ((Window, Int, Int, Int, Int) -> ())?

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
        
        glfwSetWindowUserPointer(opaque, Unmanaged.passUnretained(self).toOpaque())
    }
    
    init(opaque : OpaquePointer?) {
        self.opaque = opaque
    }
    
    public init(monitor : Monitor) {
        opaque = glfwCreateWindow(800, 600, "Bob", monitor.opaque, nil)
    }
    
    deinit {
        glfwDestroyWindow(opaque)
    }
    
    public func setKeyCallback(completion: @escaping (_ window : Window, _ key : Int, _ scancode : Int, _ action : Int, _ mods : Int) -> ()) {
        
        self.keyCallback = completion
        
        // Register C callback closure
        glfwSetKeyCallback(opaque, { (win, key, scancode, action, mods) in
            guard let userPointer = glfwGetWindowUserPointer(win) else {
                return
            }
            
            let window = Unmanaged<Window>.fromOpaque(userPointer).takeUnretainedValue()
            
            window.keyCallback!(window, Int(key), Int(scancode), Int(action), Int(mods))
//            KeyHandler.keyHandler(win, key, scancode, action, mods)
        })
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
