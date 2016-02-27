//
//  Agent2D.swift
//  rp-game-engine
//
//  Created by Ricardo Pistorello on 09/12/15.
//  Copyright © 2015 Ricardo Pistorello. All rights reserved.
//


import SpriteKit
import GameplayKit

class Agent2D: GKAgent2D, GKAgentDelegate {
    
    override var gameObject: GameObject {
        get{
            guard let gameObject = self.entity as? GameObject else {
                fatalError("Bad access component \(self.classForCoder)")
            }
            return gameObject
        }
    }
    override var transform: Transform {
        get {
            return gameObject.transform
        }
    }
    override var behavior: GKBehavior? {
        didSet {
            
        }
    }
    
    override init() {
        super.init()
        delegate = self
        maxSpeed = 40;
        maxAcceleration = 30;
        mass = 1.0
    }
    
    
    func updateAgent() {
        self.position = transform.position.float
        self.rotation = transform.localRotation.degreesToRadians().float
    }
    
    func updateTransform() {
        transform.position = position.point
        transform.localRotation = rotation.cgfloat.radiansToDegrees()
    }
    
    func agentWillUpdate(agent: GKAgent) {
        updateAgent()
    }
    
    func agentDidUpdate(agent: GKAgent) {
        updateTransform()
    }
}