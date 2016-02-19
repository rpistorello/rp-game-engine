//
//  GameObject.swift
//  rp-game-engine
//
//  Created by Ricardo Pistorello on 02/12/15.
//  Copyright © 2015 Ricardo Pistorello. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol Observer {
    init( )
}

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

    override init() {
        guard let scene = GameViewController.mainView.scene as? Scene else {
            fatalError("No Scene in current view")
        }
        self.scene = scene
        super.init()
        self.addComponent(transform)
        scene.gameObjects.insert(self)
        transform.updateRoot()
    }
    
    override func addComponent(component: GKComponent) {
        super.addComponent(component)
        scene.validateComponent(component)
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
}