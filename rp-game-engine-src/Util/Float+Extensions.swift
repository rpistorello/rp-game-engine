//
//  Float+Extensions.swift
//  living-colors
//
//  Created by Ricardo on 11/12/15.
//  Copyright © 2015 Ricardo Pistorello. All rights reserved.
//

import SpriteKit

extension Float {
    var cgfloat: CGFloat {
        return CGFloat(self)
    }
}
extension CGFloat {
    var float: Float {
        get { return Float(self) }
    }
}

extension vector_float2 {
    var point: CGPoint {
        get{
            return CGPointMake(x.cgfloat, y.cgfloat)
        }
    }
    func toPoint() -> CGPoint {
        return CGPointMake(x.cgfloat, y.cgfloat)
    }
}

extension CGPoint {
    var float: vector_float2 {
        get {
            return vector_float2(x.float,y.float)
        }
    }
}