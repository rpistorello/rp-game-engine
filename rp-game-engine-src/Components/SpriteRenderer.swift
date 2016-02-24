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
            if let gameObject = entity as? GameObject
            {
                gameObject.transform.addSprite(newSprite)
            }
        }
    }
    
    
    init(sprite: SKSpriteNode) {
        super.init()
        self.sprite = sprite
    }
    
    init(texture: SKTexture?, color: UIColor? = nil, size: CGSize? = nil, normalMap: SKTexture? = nil) {
        super.init()
        if let normalMap = normalMap {
            self.sprite = SKSpriteNode(texture: texture, normalMap: normalMap)
            return
        }
        else if let color = color {
            let _size = size ?? texture?.size() ?? CGSizeMake(100, 100)
            self.sprite = SKSpriteNode(texture: texture, color: color, size: _size)
            return
        } else if let size = size {
            self.sprite = SKSpriteNode(texture: texture, size: size)
            return
        }
        self.sprite =  SKSpriteNode(texture: texture)
    }
    
    init(imageNamed: String, normalMapped: Bool? = nil) {
        super.init()
        guard let normalMapped = normalMapped else {
            self.sprite = SKSpriteNode(imageNamed: imageNamed)
            return
        }
        self.sprite = SKSpriteNode(imageNamed: imageNamed, normalMapped: normalMapped)
    }
    
    init(color: UIColor = UIColor.whiteColor(), size: CGSize = CGSizeMake(100, 100)) {
        super.init()
        self.sprite = SKSpriteNode(color: color, size: size)
    }
    
    override func OnComponentAdded() {
        guard let newSprite = self.sprite else { return }
        transform.addSprite(newSprite)
    }
}
