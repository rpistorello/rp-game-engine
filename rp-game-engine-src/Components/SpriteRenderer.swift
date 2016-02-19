//
//  SpriteRenderer.swift
//  rp-game-engine
//
//  Created by Ricardo Pistorello on 09/12/15.
//  Copyright © 2015 Ricardo Pistorello. All rights reserved.
//

import SpriteKit

class SpriteRenderer: Component {
    var sprite: SKSpriteNode? {
        didSet {
            if let oldSprite = oldValue {
                oldSprite.removeFromParent()
            }
            guard let newSprite = self.sprite else { return }
            if entity != nil { transform.root.addChild(newSprite) }
        }
    }
    
    override func OnComponentAdded() {
        guard let newSprite = self.sprite else { return }
        transform.root.addChild(newSprite)
    }
}
