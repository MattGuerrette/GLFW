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
    /// - Parameter title: window title
    /// - Parameter width: window width in pixels
    /// - Parameter height: window height in pixels
    /// - Parameter monitor: primary monitor for window. For fullscreen window creation
    public init(_ title : String, _ width : Int, _ height : Int, monitor : Monitor? = nil) {
        opaque = glfwCreateWindow(Int32(width), Int32(height), "Bob", monitor?.opaque, nil)
        
        glfwSetWindowUserPointer(opaque, Unmanaged.passUnretained(self).toOpaque())
    }
    
    /// Initializes a window from opaque GLFW type
    /// - Parameter opaque: opaque GLFW window handle
    init(opaque : OpaquePointer?) {
        self.opaque = opaque
        
        glfwSetWindowUserPointer(opaque, Unmanaged.passUnretained(self).toOpaque())
    }
    
    deinit {
        glfwDestroyWindow(opaque)
    }
    
    /// Sets keyboard input handling callback for this window
    /// - Parameter completion: callback handler
    public func setKeyCallback(completion: @escaping (_ window : Window, _ key : Int, _ scancode : Int, _ action : Int, _ mods : Int) -> ()) {
        
        self.keyCallback = completion
        
        // Register C callback closure
        glfwSetKeyCallback(opaque, { (win, key, scancode, action, mods) in
            
            //Access 'self' registed as user pointer with opaque GLFW window
            guard let userPointer = glfwGetWindowUserPointer(win) else {
                return
            }
            
            //Convert 'Window' class type back from opqeue type
            //and call user callback
            let window = Unmanaged<Window>.fromOpaque(userPointer).takeUnretainedValue()
            
            window.keyCallback!(window, Int(key), Int(scancode), Int(action), Int(mods))
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
