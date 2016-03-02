//
//  Component.swift
//  rp-game-engine
//
//  Created by Ricardo Pistorello on 02/12/15.
//  Copyright © 2015 Ricardo Pistorello. All rights reserved.
//

import GameplayKit

@objc protocol ComponentProtocol {
    var gameObject: GameObject? { get }
    var transform: Transform? { get }
    
    optional func Awake()
    optional func Start()
}

extension GKComponent: ComponentProtocol {
    var gameObject: GameObject? {
        get{
            guard let gameObject = self.entity as? GameObject else {
                return nil
            }
            return gameObject
        }
    }
    var transform: Transform? {
        get {
            return gameObject?.transform
        }
    }
    internal func OnComponentAdded() {
        
    }
}

extension GKEntity {
    
}

class Component: GKComponent {
    var tag: String {
        get{
            return gameObject.tag
        }
        set {
            gameObject.tag = newValue
        }
    }
    internal var system: GKComponentSystem?
    var active: Bool = true {
        didSet {
            
        }
    }
    
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
    
    func detach() -> Component{
        detachFromEntity()
        detachFromSystem()
        return self
    }
    
    func detachFromEntity() -> Component{
        gameObject.removeComponentForClass(self.classForCoder)
        return self
    }
    
    func detachFromSystem() -> Component{
        system?.removeComponent(self)
        system = nil
        return self
    }
    
    override init() {
        super.init()
    }
}

