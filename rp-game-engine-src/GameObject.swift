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
            transform.hidden = !active
        }
    }
    let transform = Transform()
    var scene: Scene!
    
    //MARK: Collider
    var physicsBody: SKPhysicsBody? {
        get{return transform.physicsBody}
        set{transform.physicsBody = newValue}
    }
    
    //MARK: Init
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
    
    /** Write your code here to setup you gameObject with desired compoments */
    func setup() {
        
    }
    
    //MARK: Components
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
    
    //MARK: SKAction
    
    func runAction(action: SKAction) {
        transform.runAction(action)
    }
    
    //MARK: Update
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        if !active { return }
        super.updateWithDeltaTime(seconds)
    }
}