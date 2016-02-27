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

    private static var _currentScene: Scene? = nil
    static var currentScene: Scene? {
        get{
            return _currentScene
        }
    }
    
    private static var _loadingScene: Scene? = nil
    static var loadingScene: Scene? {
        get{
            return _loadingScene
        }
    }
    
    class func presentScene(scene: Scene, loadingScene: Scene) {
        
    }
    
    //MARK: Systems
    let transformSystem: [GKComponentSystem] = [GKComponentSystem(componentClass: Transform.self)]
    var behaviourSystems: [GKComponentSystem] = [ GKComponentSystem(componentClass: Agent2D.self),
                                                  GKComponentSystem(componentClass: Component.self)]
    var renderSystems: [GKComponentSystem] = [GKComponentSystem(componentClass: SpriteRenderer.self)]
    
    var gameObjects = Set<GameObject>()
    
    var allGameObjects: [GameObject] {
        get {return (gameObjects.map{$0}) }
    }
    
    var lastUpdateTime = NSTimeInterval(0)
    
    
    //MARK: Init
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        physicsWorld.contactDelegate = self
        
        Scene._loadingScene = self
        self.loadObjects()
        
        Scene._loadingScene = nil
        Scene._currentScene = self
        self.initComponents()
    }
    
    
    override init() {
        super.init(size: UIScreen.mainScreen().bounds.size)
    }
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadObjects() { }
    
    //MARK: Components
    func validateComponent(component: GKComponent) {
        var targetSystem: [GKComponentSystem]?
        if component is SpriteRenderer {
            targetSystem = renderSystems
        }
        else if component is Transform {
            targetSystem = transformSystem
        }
        
        if let targetSystem = targetSystem {
            targetSystem.first?.addComponent(component)
            (component as? Component)?.system = targetSystem.first
            return
        }
        
        targetSystem = behaviourSystems.filter { $0.componentClass == component.classForCoder }
        guard let foundSystem = targetSystem?.first else {
            let newSystem = GKComponentSystem(componentClass: component.classForCoder.self)
            behaviourSystems += [newSystem]
            newSystem.addComponent(component)
            (component as? Component)?.system = newSystem
            return
        }
        foundSystem.addComponent(component)
    }
    
    func initComponents() {
        let transformComponents = allComponents(transformSystem)
        transformComponents.forEach{ $0.Awake?() }
        transformComponents.forEach{ $0.Start?() }

    }
    
    private func allComponents(systems: [GKComponentSystem]) -> [ComponentProtocol]   {
        var components = [GKComponent]()
        systems.map { $0.components }.forEach { components += $0 }
        return components
    }
    
    //MARK: Update
    override func update(currentTime: NSTimeInterval) {
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime;
        }
        let delta = currentTime - lastUpdateTime;
        lastUpdateTime = currentTime;
        Time.sharedInstance._deltaTime = delta
        
        //Update by priority
        transformSystem.forEach { $0.updateWithDeltaTime(delta) }
        let behaviourComponents = allComponents(behaviourSystems)
        behaviourComponents.forEach { ($0 as! GKComponent).updateWithDeltaTime(delta) }
        behaviourComponents.forEach { $0.Update?() }
        behaviourComponents.forEach { $0.LateUpdate?() }
        renderSystems.forEach { $0.updateWithDeltaTime(delta) }
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
