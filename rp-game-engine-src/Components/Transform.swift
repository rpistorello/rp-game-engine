//
//  Transform.swift
//  rp-game-engine
//
//  Created by Ricardo Pistorello on 02/12/15.
//  Copyright © 2015 Ricardo Pistorello. All rights reserved.
//



import SpriteKit

class Transform: Component {
    internal let root = SKNode()
    
    override var active: Bool {
        didSet {
            active = true
        }
    }
    
    //MARK: Parent
    private var _parent: Transform?
    var parent: Transform? {
        get{ return _parent}
    }
    
    //MARK: Position
    var localposition: CGPoint {
        get{ return self.root.position }
        set{
            root.position = newValue
            updateGlobalposition()
        }
    }
    
    private var _position: CGPoint = CGPointZero
    var position: CGPoint? {
        get {
            guard let newParent = root.parent,
                  let scene = root.scene else {
                    print("Parent or scene not found \(gameObject.classForCoder)")
                    return nil }
            _position = scene.convertPoint(root.position, fromNode: newParent)
            return self._position
        }
        set {
            guard let value = newValue else { return }
            self._position = value
            updateLocalPosition()
        }
    }
    
    //MARK: Rotation
    private var _rotation = CGFloat(0)
    var rotation: CGFloat {
        get{ return _rotation }
        set{
            self._rotation = newValue
            updateLocalRotation()
        }
    }
    
    var localRotation: CGFloat {
        get { return root.zRotation.radiansToDegrees() }
        set { root.zRotation = newValue.degreesToRadians() }
    }
    
    //MARK: Scale
    var scale: CGPoint {
        get { return root.scaleAsPoint }
        set { root.scaleAsPoint = newValue }
    }
    
    
    //MARK: Handlers
    private func updateGlobalposition() {
        guard let newParent = root.parent,
              let scene = root.scene else { return }
        _position = scene.convertPoint(root.position, fromNode: newParent)
    }
    
    private func updateLocalPosition() {
        guard let parent = root.parent,
              let scene = root.scene else { return }
        root.position = parent.convertPoint(_position, fromNode: scene)
    }
    
    private func updateGlobalRotation() {
        _rotation = findRotation() + root.zRotation.radiansToDegrees()
    }
    
    private func updateLocalRotation() {
        localRotation = _rotation - findRotation()
    }
    
    func findRotation() -> CGFloat{
        guard let parent = self.parent else {
            return localRotation
        }
        return parent.findRotation() + localRotation
    }
    
    //MARK: Functions
    func setParent(newParent: Transform?, worldPositionStays: Bool = true) {
        self._parent = newParent
        updateRoot()
        if worldPositionStays { updateLocalPosition() }
        updateLocalRotation()
        
    }
    
    func addChild(child: Transform) {
        child.setParent(self)
    }
    
    internal func updateRoot() {
        if self.root.parent != nil { self.root.removeFromParent() }
        guard let tparent = self.parent else {
//            addToScene()
            self.gameObject.scene.addChild(root)
            return
        }
        tparent.root.addChild(self.root)
    }
    
    func runAction(action: SKAction) {
        root.runAction(action)
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        updateGlobalposition()
        updateGlobalRotation()
    }
}
