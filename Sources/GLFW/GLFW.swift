import cglfw

public struct GLFW {
    
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
    
    public enum Key : Int {
        case unknown = -1
        case space = 32
        case apostrophe = 39
        case comma = 44
        case minus = 45
        case period = 46
        case slash = 47
        case k0 = 48
        case k1 = 49
        case k2 = 50
        case k3 = 51
        case k4 = 52
        case k5 = 53
        case k6 = 54
        case k7 = 55
        case k8 = 56
        case k9 = 57
        case semicolon = 59
        case equal = 61
        case A = 65
        case B = 66
        case C = 67
        case D = 68
        case E = 69
        case F = 70
        case G = 71
        case H = 72
        case I = 73
        case J = 74
        case K = 75
        case L = 76
        case M = 77
        case N = 78
        case O = 79
        case P = 80
        case Q = 81
        case R = 82
        case S = 83
        case T = 84
        case U = 85
        case V = 86
        case W = 87
        case X = 88
        case Y = 89
        case Z = 90
        case leftBracket = 91
        case backslash = 92
        case rightBracket = 93
        case graveAccent = 96
        case world1 = 161
        case world2 = 162
    }
    
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
        if self {
            return 1
        } else {
            return 0
        }
    }
}
