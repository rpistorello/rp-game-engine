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
    
    var tag: String = "Untagged" {
        didSet {
            if tag.isEmpty { tag = "Untagged" }
        }
    }
    
    //MARK: Physics
    internal var OnCollisionEnter: [((Collision2D) -> ())] = []
    internal var OnCollisionStay: [((Collision2D) -> ())] = []
    internal var OnCollisionExit: [((Collision2D) -> ())] = []
    
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
        component.OnComponentAdded()
        updateCollisions(component)
    }
    
    internal func updateCollisions(component: GKComponent) {
        if component.conformsToProtocol(BehaviourProtocol) {
            OnCollisionEnter.removeAll(keepCapacity: true)
            OnCollisionStay.removeAll(keepCapacity: true)
            OnCollisionExit.removeAll(keepCapacity: true)
            
            let behaviours = components.map{ $0 as? BehaviourProtocol }
                .filter{ $0 != nil }
                .map{ $0! }
            
            for behaviour in behaviours {
                OnCollisionEnter += evaluateCollision(behaviour.OnCollisionEnter)
                OnCollisionStay += evaluateCollision(behaviour.OnCollisionStay)
                OnCollisionExit += evaluateCollision(behaviour.OnCollisionExit)
            }
        }
    }
    
    private func evaluateCollision( block: ((Collision2D) -> ())?) -> [(Collision2D) -> ()] {
        guard let block = block as ((Collision2D) -> ())! else {
            return []
        }
        return [block]
    }
    
    override func removeComponentForClass(componentClass: AnyClass) {
        super.removeComponentForClass(componentClass)
        if let component = (components.filter{
            $0.classForCoder == componentClass.self
            }).first {
                updateCollisions(component)
                (component as? Component)?.detachFromSystem()
        }
    }

    func addChild(child: GameObject) {
        child.transform.setParent(self.transform)
    }
    
    //MARK: Message
    func SendMessage(methodName: String) {
        let method = Selector(methodName)
        components.filter { $0.respondsToSelector(method) }
            .forEach{ $0.performSelector(method) }
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