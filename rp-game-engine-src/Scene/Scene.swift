//
//  Scene.swift
//  rp-game-engine
//
//  Created by Ricardo Pistorello on 02/12/15.
//  Copyright © 2015 Ricardo Pistorello. All rights reserved.
//

import SpriteKit
import GameplayKit

class Scene: SKScene {
    static var isLoadingScene = false

    static var _currentScene: Scene? = nil
    static var currentScene: Scene? {
        get{
            return _currentScene
        }
    }
    
    static var _loadingScene: Scene? = nil
    static var loadingScene: Scene? {
        get{
            return _loadingScene
        }
    }
    
    var systems: [GKComponentSystem] = [
        GKComponentSystem(componentClass: Transform.self),
        GKComponentSystem(componentClass: Agent2D.self),
        GKComponentSystem(componentClass: Component.self),
        GKComponentSystem(componentClass: SpriteRenderer.self)
    ]
    
    var gameObjects = Set<GameObject>()
    
    var allGameObjects: [GameObject] {
        get {return (gameObjects.map{$0}) }
    }
    
    var lastUpdateTime = NSTimeInterval(0)
    
    func validateComponent(component: GKComponent) {
        let system = systems.filter { $0.componentClass == component.classForCoder }
        guard let sys = system.first else {
            fatalError("Component System not declared")
        }
        sys.addComponent(component)
    }
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        loadObjects()
        
        for sys in systems {
            for comp in sys.components {
                comp.Awake()
            }
        }
        
        for sys in systems {
            for comp in sys.components {
                comp.Start()
            }
        }
        
    }
    
    func loadObjects() {
        
    }
    override func update(currentTime: NSTimeInterval) {
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime;
        }
        let delta = currentTime - lastUpdateTime;
        lastUpdateTime = currentTime;
        Time.sharedInstance._deltaTime = delta
        for componentSystem in systems {
            componentSystem.updateWithDeltaTime(delta)
        }
    }
    
    
    override init(size: CGSize) {
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class Time {
    //MARK: Time
    private var _deltaTime = Double(0)
    class var deltaTime: Double {
        get { return Time.sharedInstance._deltaTime }
    }
    static let sharedInstance = Time()
    
}
