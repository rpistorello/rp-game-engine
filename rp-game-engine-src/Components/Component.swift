//
//  Component.swift
//  rp-game-engine
//
//  Created by Ricardo Pistorello on 02/12/15.
//  Copyright © 2015 Ricardo Pistorello. All rights reserved.
//

import GameplayKit

extension GKComponent {
    var gameObject: GameObject {
        get{
            guard let gameObject = self.entity as? GameObject else {
                fatalError("Bad access component \(self.classForCoder)")
            }
            return gameObject
        }
    }
    var transform: Transform {
        get {
            return gameObject.transform
        }
    }
}

class Component: GKComponent {
    private var system: GKComponentSystem?
    var active: Bool = true {
        didSet {
            
        }
    }
    
    override func Awake() {
        
    }
    
    override func Start() {
        
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

