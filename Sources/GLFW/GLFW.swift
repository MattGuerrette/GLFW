import cglfw

public struct GLFW {
    
    public static func initialize() {
        if glfwInit() != GLFW_TRUE {
            fatalError("Failed to initialize GLFW")
        }
    }
}
