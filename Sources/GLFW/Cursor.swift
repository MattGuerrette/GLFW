//
// Created by mguerrette on 7/11/19.
//

import Foundation
import cglfw


public class Cursor {
    
    public enum Shape : Int32 {
        case arrow = 0x00036001
        case ibeam = 0x00036002
        case crosshair = 0x00036003
        case hand = 0x00036004
        case hresize = 0x00036005
        case vresize = 0x00036006
    }

    let opaque : OpaquePointer?

    public init(shape : Shape) {
        opaque = glfwCreateStandardCursor(shape.rawValue)
    }

    deinit {
        print("Destroyed cursor")
        glfwDestroyCursor(opaque)
    }

}

//public enum CursorShape : Int32 {
//    case arrow = 0x00036001
//    case ibeam = 0x00036002
//    case crosshair = 0x00036003
//    case hand = 0x00036004
//    case hresize = 0x00036005
//    case vresize = 0x00036006
//}
