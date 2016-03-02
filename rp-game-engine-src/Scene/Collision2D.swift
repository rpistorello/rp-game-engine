//
//  Collision2D.swift
//  rp-game-engine-example
//
//  Created by Ricardo on 02/03/16.
//  Copyright © 2016 Ricardo Pistorello. All rights reserved.
//

import SpriteKit

class Collision2D: NSObject {
    internal let contact: SKPhysicsContact!
    var tag: String {
        get{ return gameObject.tag }
    }
    let gameObject: GameObject
    
    var physicsBody: SKPhysicsBody!
    var contactPoint: CGPoint { get { return contact.contactPoint } }
    var contactNormal: CGVector { get { return contact.contactNormal } }
    var collisionImpulse: CGFloat { get { return contact.collisionImpulse } }
    
    internal init(other: GameObject, contact: SKPhysicsContact) {
        self.contact = contact
        self.gameObject = other
        self.physicsBody = gameObject.physicsBody
    }
}