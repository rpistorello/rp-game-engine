//
//  Behaviour.swift
//  rp-game-engine-example
//
//  Created by Ricardo on 27/02/16.
//  Copyright © 2016 Ricardo Pistorello. All rights reserved.
//

import Foundation


@objc protocol BehaviourProtocol {
    //MARK: Update
    
    /** Called before LateUpdate() */
    optional func Update()
    
    /** Called after Update() */
    optional func LateUpdate()
    
    //MARK: Collision
    
    /** Called every time the object start to collide with other object */
    optional func OnCollisionEnter(other: Collision2D)
    
    /** Called every frame the object is in contact with other object */
    optional func OnCollisionStay(other: Collision2D)
    
    /** Called every time the object stop to collide with other object */
    optional func OnCollisionExit(other: Collision2D)
}

//MARK: Behaviour Class
class Behaviour: Component, BehaviourProtocol {
    
}