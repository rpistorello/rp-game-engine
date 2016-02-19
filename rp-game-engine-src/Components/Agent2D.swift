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
            updateAgent()
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
        self.position = transform.position?.float ?? CGPointZero.float

    
    
        self.rotation = transform.rotation.degreesToRadians().float
    }
    
    override func Awake() {
        self.position = transform.position?.float ?? CGPointZero.float
        print("agent awake \(classForCoder)")
    }
    
    override func Start() {
        
        print("agent start \(classForCoder)")
    }
    
    func updateTransform(agent: GKAgent2D) {
        transform.position = agent.position.point
//        transform.rotation = agent.rotation.cgfloat.radiansToDegrees()
    }
    
    func agentWillUpdate(agent: GKAgent) {
        guard
            let _ = agent as? GKAgent2D,
            let _ = gameObject.physicsBody
            else { return }
        updateAgent()
    }
    
    func agentDidUpdate(agent: GKAgent) {
        guard let agent = agent as? GKAgent2D else {
            return
        }
        transform.position = agent.position.point
//        transform.rotation = agent.rotation.cgfloat.radiansToDegrees()
        updateTransform(agent)
    }
}