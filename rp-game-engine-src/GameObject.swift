//
//  GameObject.swift
//  rp-game-engine
//
//  Created by Ricardo Pistorello on 02/12/15.
//  Copyright © 2015 Ricardo Pistorello. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameObject: GKEntity {
    var active: Bool = true {
        didSet {
            transform.root.hidden = !active
        }
    }
    let transform = Transform()
    var scene: Scene!
    
    var physicsBody: SKPhysicsBody? {
        get{return transform.root.physicsBody}
        set{transform.root.physicsBody = newValue}
    }
    
    func setup() {
        
    }
    init(scene: Scene? = nil) {
        super.init()
        guard let targetScene = scene ?? Scene.loadingScene ?? Scene.currentScene else {
            fatalError("No Scene were found")
        }
        self.scene = targetScene
        targetScene.transformSystem.first!.addComponent(transform)
        targetScene.gameObjects.insert(self)
        addComponent(transform)
        setup()
    }
    
    override func addComponent(component: GKComponent) {
        scene.validateComponent(component)
        super.addComponent(component)
        if let component = component as? Component {
            component.OnComponentAdded()
        }
    }
    
    func addChild(child: GameObject) {
        child.transform.setParent(self.transform)
    }
    
    func runAction(action: SKAction) {
        transform.root.runAction(action)
    }
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        if !active { return }
        super.updateWithDeltaTime(seconds)
    }
}