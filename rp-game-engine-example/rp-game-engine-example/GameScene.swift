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
        //NoSpriteObject is subclass of GameObject
        //Instantiated GameObjects or subclasses are automaticaly added to Scene
        for _ in 0...2 {
            let object = NoSpriteObject()
            objects += [object]
        }
        //Transform component store the object's position
        objects[0].transform.position = CGPoint(x: 100, y: 100)
        objects[1].transform.position = CGPoint(x: 300, y: 500)
        objects[2].transform.position = CGPoint(x: 200, y: 300)
        
        
        //Rotation with SKAction
        let min = CGFloat(0.0).degreesToRadians()
        let max = CGFloat(90).degreesToRadians()
        let rotateToMinAngle = SKAction.rotateToAngle(min, duration: 5.0)
        let rotateToMaxAngle = SKAction.rotateToAngle(max, duration: 5.0)
        let rotateClockwise = SKAction.rotateByAngle(max, duration: 5.0)
        
        objects[0].transform.localRotation = min
        objects[1].transform.localRotation = min
        
        objects[0].runAction(SKAction.repeatActionForever(SKAction.sequence([rotateToMinAngle, rotateToMaxAngle])))
        objects[1].runAction(SKAction.repeatActionForever(SKAction.sequence([rotateToMaxAngle, rotateToMinAngle])))
        objects[2].runAction(SKAction.repeatActionForever(rotateClockwise))
        
        let label = SKLabelNode(text: "Touch to change parent")
        addChild(label)
        label.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame) - CGRectGetHeight(label.frame))
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let location = touches.first!.locationInNode(self)
        nodeAtPoint(location)
        
        //Switch parent on touching screen
        parentSwitch = !parentSwitch
        objects[2].transform.setParent(parentSwitch ? objects[0].transform : objects[1].transform)
    }
}