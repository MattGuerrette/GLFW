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
