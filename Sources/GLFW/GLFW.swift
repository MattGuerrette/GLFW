import cglfw

public struct GLFW {

    /// version string of GLFW being used
    public static var version : String = {
       
        var major : Int32 = 0
        var minor : Int32 = 0
        var revision : Int32 = 0
        glfwGetVersion(&major, &minor, &revision)
        
        return "\(major).\(minor).\(revision)"
    }()

    /// Initializes GLFW
    public static func initialize() {
        if glfwInit() != GLFW_TRUE {
            fatalError("Failed to initialize GLFW")
        }
    }

    /// Terminates GLFW
    public static func terminate() {
        glfwTerminate()
    }

    /// Polls for input events
    public static func pollEvents() {
        glfwPollEvents()
    }

    public static func windowHint(_ hint : Int, _ value : Int) {
        glfwWindowHint(Int32(hint), Int32(value))
    }

    public static func windowHint(_ hint : WindowHint, _ value : Bool) {
        glfwWindowHint(Int32(hint.rawValue), value.int32Value())
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

extension Bool {
    func int32Value() -> Int32 {
        return self ? 1 : 0
    }

    func intValue() -> Int {
        return self ? 1 : 0
    }
}


extension GLFW {
    
    public enum WindowHint : Int {
        case resizable = 0x00020003
        case visible = 0x00020004
        case decorated = 0x00020005
        case focused = 0x00020001
        case autoIconify = 0x00020006
        case floating = 0x00020007
        case maximized = 0x00020008
        case centerCursor = 0x00020009
        case transparentFramebuffer = 0x0002000A
        case focusOnShow = 0x0002000C
        case scaleToMonitor = 0x0002200C
    }
    
    public enum Action : Int {
        case unknown = -1
        case released = 0
        case pressed = 1
        case repeated = 2
    }
    
    public struct Modifier : OptionSet {
        public let rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        public static let none = Modifier(rawValue: 0)
        public static let shift = Modifier(rawValue: 0x0001)
        public static let control = Modifier(rawValue: 0x0002)
        public static let alt = Modifier(rawValue: 0x0004)
        public static let `super` = Modifier(rawValue: 0x0008)
        public static let capsLock = Modifier(rawValue: 0x0010)
        public static let numLock = Modifier(rawValue: 0x0020)
    }
    

}
