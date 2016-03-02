//
//  CollisionTest.swift
//  rp-game-engine-example
//
//  Created by Ricardo on 02/03/16.
//  Copyright © 2016 Ricardo Pistorello. All rights reserved.
//

import UIKit

class CollisionTest: Behaviour {
    func OnCollisionEnter(other: Collision2D) {
        print("\(tag): I collided with \(other.tag)")
        //Change color of the sprite to red
        let spriteComponent = gameObject.componentForClass(SpriteRenderer)
        spriteComponent?.sprite?.color = UIColor.redColor()
    }
    
    func OnCollisionExit(other: Collision2D) {
        //Return to white color
        let spriteComponent = gameObject.componentForClass(SpriteRenderer)
        spriteComponent?.sprite?.color = UIColor.whiteColor()
    }
}
