//
//  NoSpriteObject.swift
//  rp-game-engine-example
//
//  Created by Ricardo on 22/02/16.
//  Copyright © 2016 Ricardo Pistorello. All rights reserved.
//

class NoSpriteObject: GameObject {
    override func setup() {
        let spriteComponent = SpriteRenderer()
        addComponent(spriteComponent)
    }
}