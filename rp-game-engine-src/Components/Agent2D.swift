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
    
    
    override func Awake() {
        
    }
    
    override func Start() {
        
    }
    
    
    func updateAgent() {
        self.position = transform.position.float
        self.rotation = transform.rotation.degreesToRadians().float
    }
    
    func updateTransform() {
        transform.position = position.point
        transform.rotation = rotation.cgfloat.radiansToDegrees()
    }
    
    func agentWillUpdate(agent: GKAgent) {
        updateAgent()
    }
    
    func agentDidUpdate(agent: GKAgent) {
        updateTransform()
    }
}