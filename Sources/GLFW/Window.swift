//
//  Window.swift
//  
//
//  Created by Matthew Guerrette on 7/9/19.
//

import cglfw

public class Window {
    
    private var window : OpaquePointer?
    
    public var shouldClose : Bool {
        get {
            guard window != nil else {
                fatalError("Window uninitialized")
            }
            
            return glfwWindowShouldClose(window) == GLFW_TRUE
        }
    }
    
    public func show() {
        glfwShowWindow(window)
    }
    
    public func hide() {
        glfwHideWindow(window)
    }
    
    public init() {
        window = glfwCreateWindow(800, 600, "Bob", nil, nil)
    }
}
