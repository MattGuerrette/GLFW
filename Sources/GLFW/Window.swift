//
//  Window.swift
//  
//
//  Created by Matthew Guerrette on 7/9/19.
//

import cglfw

public enum WindowHint {
    
}

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
}
