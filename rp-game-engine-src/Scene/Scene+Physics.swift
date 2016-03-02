//
//  Scene+Physics.swift
//  rp-game-engine-example
//
//  Created by Ricardo on 02/03/16.
//  Copyright © 2016 Ricardo Pistorello. All rights reserved.
//

import SpriteKit

internal class Physics: NSObject, SKPhysicsContactDelegate {
    
    //MARK: Contact
    var contactEnter = [Contact]()
    var contactStay = [Contact]()
    var contactExit = [Contact]()
    
    func didBeginContact(contact: SKPhysicsContact) {
        let collision = Contact(contact: contact)
        if !collision.isNil {contactEnter += [collision]}
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        let collision = Contact(contact: contact)
        if !collision.isNil {contactExit += [collision]}
    }
    
    internal func handleCollisions() {
        contactEnter.forEach { $0.collisionEnter() }
        contactExit.forEach { $0.collisionExit() }
        
        //Verify if a collisionStay is exiting
        if !contactExit.isEmpty && !contactStay.isEmpty {
            
            var toRemove = [Contact]()
            for exit in contactExit {
                for stay in contactStay {
                    if exit.objectA === stay.objectA
                        && exit.objectB === stay.objectB {
                            toRemove += [stay]
                            break
                    }
                }
            }
            contactStay = contactStay.filter{ !toRemove.contains($0) }
        }
        
        contactStay.forEach { $0.collisionStay() }
        contactStay += contactEnter
        contactEnter.removeAll(keepCapacity: true)
        contactExit.removeAll(keepCapacity: true)
    }
}

internal class Contact: NSObject {
    var objectA: GameObject?
    var objectB: GameObject?
    let contact: SKPhysicsContact
    var isNil: Bool {
        get{ return objectA == nil || objectB == nil }
    }
    
    private func getCollisions() -> (sendToA: Collision2D, sendToB: Collision2D ) {
        let sendToA = Collision2D(other: objectB!, contact: contact)
        let sendToB = Collision2D(other: objectA!, contact: contact)
        return (sendToA, sendToB)
    }
    
    
    internal init(contact: SKPhysicsContact) {
        self.contact = contact
        guard let objA = contact.bodyA.node as? Root,
            let objB = contact.bodyB.node as? Root else {
                print("One or more colliders are not a Collider2D")
                return
        }
        self.objectA = objA.gameObject
        self.objectB = objB.gameObject
    }
    
    internal func collisionEnter() {
        let collisions = getCollisions()
        self.objectA!.OnCollisionEnter.forEach{ $0(collisions.0) }
        self.objectB!.OnCollisionEnter.forEach{ $0(collisions.1) }
    }
    
    internal func collisionStay() {
        let collisions = getCollisions()
        self.objectA!.OnCollisionStay.forEach{ $0(collisions.0) }
        self.objectB!.OnCollisionStay.forEach{ $0(collisions.1) }
    }
    
    internal func collisionExit() {
        let collisions = getCollisions()
        self.objectA!.OnCollisionExit.forEach{ $0(collisions.0) }
        self.objectB!.OnCollisionExit.forEach{ $0(collisions.1) }
    }
    
    internal func behaviourComponents(gameObject: GameObject) -> [BehaviourProtocol] {
        var components = [BehaviourProtocol]()
        let behaviours = gameObject.components.filter{ $0.conformsToProtocol(BehaviourProtocol) }
            .map{ $0 as! BehaviourProtocol }
        components += behaviours
        return components
    }
    
}
