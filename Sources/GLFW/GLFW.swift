import cglfw

public struct GLFW {
    
    public static var version : String = {
       
        var major : Int32 = 0
        var minor : Int32 = 0
        var revision : Int32 = 0
        glfwGetVersion(&major, &minor, &revision)
        
        return "\(major).\(minor).\(revision)"
    }()
    
    public static func initialize() {
        if glfwInit() != GLFW_TRUE {
            fatalError("Failed to initialize GLFW")
        }
    }
    
    public static func terminate() {
        glfwTerminate()
    }
    
    public static func pollEvents() {
        glfwPollEvents()
    }
    
    public static func setErrorCallback(completion: @escaping (_ error : Int, _ description : String?) -> ()) {
        // Store user specified handler in global
        ErrorHandler.shared().handler = completion
        
        // Register C callback closer and call internal handler
        glfwSetErrorCallback { (error, description) in
            ErrorHandler.errorHandler(error, description)
        }
    }
    
    public static func setKeyCallback(window: Window, completion: @escaping (_ window : Window, _ key : Int, _ scancode : Int, _ action : Int, _ mods : Int) -> ()) {
        
        // Store user specified handler in global
        KeyHandler.shared().handler = completion
        
        // Register C callback closure
        glfwSetKeyCallback(window.opaque, { (win, key, scancode, action, mods) in
                KeyHandler.keyHandler(win, key, scancode, action, mods)
        })
    }
}


fileprivate class ErrorHandler {
    private static var sharedHandler : ErrorHandler = {
        let handler = ErrorHandler()
        return handler
    }()
    
    var handler : ((Int, String?) -> ())?
    
    class func shared() -> ErrorHandler {
        return sharedHandler
    }
    
    class func errorHandler(_ error: Int32, _ description: UnsafePointer<Int8>?) {
        guard let handler = ErrorHandler.shared().handler else {
            return
        }
        
        if let desc = description {
            handler(Int(error), String.init(cString: desc))
        } else {
            handler(Int(error), nil)
        }
    }
}

fileprivate class KeyHandler {
    private static var sharedHandler : KeyHandler = {
        let handler = KeyHandler()
        return handler
    }()
    
    var handler : ((Window, Int, Int, Int, Int) -> ())?
    
    class func shared() -> KeyHandler {
        return sharedHandler
    }
    
    class func keyHandler(_ window : OpaquePointer?,
                          _ key : Int32,
                          _ scancode : Int32,
                          _ action : Int32,
                          _ mods : Int32) {
        guard let handler = KeyHandler.shared().handler else {
            return
        }
        
        handler(Window(opaque: window), Int(key), Int(scancode), Int(action), Int(mods))
    }
}

extension Bool {
    func glfwBool() -> Int32 {
        if self {
            return GLFW_TRUE
        } else {
            return GLFW_FALSE
        }
    }
}
