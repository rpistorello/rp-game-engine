//
//  ComponentDelegate.swift
//  rp-game-engine
//
//  Created by Ricardo Pistorello on 11/12/15.
//  Copyright © 2015 Ricardo Pistorello. All rights reserved.
//

import GameplayKit

protocol ComponentDelegate {
    func Awake()
    func Start()
    func Update()
    func LateUpdate()
}

extension GKComponent: ComponentDelegate {
    func Awake() {}
    func Start() {}
    func Update() {}
    func LateUpdate() {}
}
