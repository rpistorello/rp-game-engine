//
//  NoSpriteObject.swift
//  rp-game-engine-example
//
//  Created by Ricardo on 22/02/16.
//  Copyright © 2016 Ricardo Pistorello. All rights reserved.
//

import GameKit
class NoSpriteObject: GameObject {
    override func setup() {
        //Add sprite
        let spriteComponent = SpriteRenderer()
        addComponent(spriteComponent)
        
        //Add a physicsBody for collision detection
        physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(100, 100))
        physicsBody?.contactTestBitMask = 1
        physicsBody?.collisionBitMask = 1
        
        //Add a Behaviour to handle collisions
        addComponent(CollisionTest())
    }
}