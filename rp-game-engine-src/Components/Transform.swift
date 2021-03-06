//
//  Transform.swift
//  rp-game-engine
//
//  Created by Ricardo Pistorello on 02/12/15.
//  Copyright © 2015 Ricardo Pistorello. All rights reserved.
//



import SpriteKit

internal class Root: SKNode {
    var transform: Transform!
    var gameObject: GameObject!
    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Transform: Component {
    private let root = Root()
    
    override var active: Bool {
        didSet {
            active = true
        }
    }
    
    var hidden: Bool {
        get { return root.hidden }
        set { root.hidden = newValue }
    }
    
    internal override init() {
        super.init()
        root.transform = self
    }
    
    //MARK: Parent
    private var _parent: Transform?
    var parent: Transform? {
        get{ return _parent }
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
    var position: CGPoint {
        get {
            guard let newParent = root.parent,
                  let scene = root.scene else {
                    print("Parent or scene not found \(gameObject.classForCoder)")
                    return self._position
            }
            _position = scene.convertPoint(root.position, fromNode: newParent)
            return self._position
        }
        set {
            self._position = newValue
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
    var lossyScale: CGPoint {
        get {
            let parentLossyScale = findParentLossyScale()
            return CGPointMake(parentLossyScale.x * scale.x, parentLossyScale.y * scale.y)
        }
    }
    
    var scale: CGPoint {
        get { return root.scaleAsPoint }
        set { root.scaleAsPoint = newValue }
    }
    
    //MARK: Collider
    internal var physicsBody: SKPhysicsBody? {
        get{ return root.physicsBody}
        set{ root.physicsBody = newValue}
    }
    
    //MARK: Position Handlers
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
    
    //MARK: Rotation Handlers
    private func updateGlobalRotation() {
        _rotation = findParentRotation() + root.zRotation.radiansToDegrees()
    }
    
    private func updateLocalRotation() {
        localRotation = _rotation - findParentRotation()
    }
    
    func findParentRotation() -> CGFloat{
        guard let parent = self.parent else {
            return localRotation
        }
        return parent.findParentRotation() + localRotation
    }
    
    //MARK: Scale Handlers
    
    func findParentLossyScale() -> CGPoint{
        guard let parent = self.parent else {
            return scale
        }
        let parentLossyScale = parent.findParentLossyScale()
        return CGPointMake(parentLossyScale.x * scale.x, parentLossyScale.y * scale.y)
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
    
    internal func addSprite(sprite: SKSpriteNode) {
            root.addChild(sprite)
    }
    
    override func OnComponentAdded() {
        root.gameObject = gameObject
        updateRoot()
    }
    
    private func updateRoot() {
        if self.root.parent != nil { self.root.removeFromParent() }
        guard let tparent = self.parent else {
            self.gameObject.scene.addChild(root)
            return
        }
        tparent.root.addChild(self.root)
    }
    
    func runAction(action: SKAction) {
        root.runAction(action)
    }
    
    //MARK: Update
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        updateGlobalposition()
        updateGlobalRotation()
    }
}
