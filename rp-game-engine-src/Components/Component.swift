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
    optional func Update()
    optional func LateUpdate()
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
}

class Component: GKComponent {
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
    
    func remove(){
        system?.removeComponent(self)
        gameObject.removeComponentForClass(self.classForCoder)
    }
    
    internal func OnComponentAdded() {
        
    }
    
    override init() {
        super.init()
    }
}

