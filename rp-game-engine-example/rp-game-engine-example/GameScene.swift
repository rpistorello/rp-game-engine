//
//  GameScene.swift
//  rp-game-engine-example
//
//  Created by Ricardo on 19/02/16.
//  Copyright © 2016 Ricardo Pistorello. All rights reserved.
//

import SpriteKit

class GameScene: Scene {
    var objects = [GameObject]()
    var parentSwitch = true
    
    override func loadObjects() {
        objects = [GameObject(), GameObject(), GameObject()]
        
        for object in objects {
            let sprite = SpriteRenderer()
            sprite.sprite = SKSpriteNode(imageNamed: "noSprite")
            object.addComponent(sprite)
        }
        
        
        objects[0].transform.position = CGPoint(x: 100, y: 200)
        objects[1].transform.position = CGPoint(x: 300, y: 600)
        objects[2].transform.position = CGPoint(x: 200, y: 400)
        
        let max = CGFloat(90).degreesToRadians()
        let min = CGFloat(0.000000).degreesToRadians()
        
        objects[0].transform.localRotation = max
        objects[0].runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.rotateToAngle(min, duration: 5.0),SKAction.rotateToAngle(max, duration: 5.0)])))
        objects[1].runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.rotateToAngle(max, duration: 5.0),SKAction.rotateToAngle(min, duration: 5.0)])))
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let location = touches.first!.locationInNode(self)
        nodeAtPoint(location)
        
        //Switch parent on touching screen
        parentSwitch = !parentSwitch
        objects[2].transform.setParent(parentSwitch ? objects[0].transform : objects[1].transform)
    }
}