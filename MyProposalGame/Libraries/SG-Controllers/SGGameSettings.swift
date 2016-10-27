/*
 * Copyright (c) 2015 Neil North.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation
import CoreGraphics
import SpriteKit



enum AnimationState: String {
    case Idle = "Idle_"
    case Dead = "Dead_"
    case Jump = "Jump__"
    case JumpFire = "Jump_Throw_"
    case Run = "Run_"
    case Slide = "Slide_"
    case IdleFire = "Throw_"
    case Rise = "Rise_"
    case Attack = "Attack__"
}

enum ColliderType:UInt32 {
    case Player         = 0
    case Enemy          = 0b1
    case Destroyable    = 0b10
    case Wall           = 0b100
    case Collectable    = 0b1000
    case EndLevel       = 0b10000
    case Projectile     = 0b100000
    case None           = 0b1000000
    case KillZone       = 0b10000000
    case InvisibleWall  = 0b100000000
    case Princess       = 0b1000000000
}

struct GameSettings {
    
    static let standarFontName = "ArcadeClassic"
    
    struct Builder {
        static var ALL_Black_Background: Bool = false
        static let BUILDER_LEVEL = 1
    }
    
    /**
     Standard options when game is run in debug mode.
     */
    
    struct Debugging {
        
        static let ALL_ShowFrameRate: Bool = true
        static let ALL_ShowNodeCount: Bool = true
        
        static let IOS_ShowDrawCount: Bool = false
        static let IOS_ShowQuadCount: Bool = false
        static let IOS_ShowPhysics  : Bool = false
        static let IOS_ShowFields   : Bool = false
        
        static let ALL_TellMeStatus : Bool = true
    }
    
    /**
     Standard options for the game in all modes.
     */
    
    struct Defaults {
        
        static let ALL_Identifier         : String = "com.northysoftware.example"
        
        static let OSX_Start_FullScreen   : Bool = false
        static let OSX_DefaultResolution  : Int  = 0
        
        static let OSX_Resolutions        : [(CGFloat, CGFloat)] = [(1024, 768), (1280, 800)]
        static let ALL_Introduce          : Bool = false
        
    }
    
    /**
     Game standards in all modes.
     */
    
    struct GameParams {
        
        struct zValues {
            static let zBackground01:CGFloat = 10
            static let zBackground02:CGFloat = 20
            static let zBackground03:CGFloat = 30
            static let zWorld:CGFloat = 100.0
            static let zWorldFront:CGFloat = 150.0
            static let zPlayer: CGFloat = 125.0
        }
        
    }
    
}
