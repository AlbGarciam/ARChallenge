//
//  Sphere.swift
//  ARChallenge
//
//  Created by Alberto García-Muñoz on 23/06/2019.
//  Copyright © 2019 SoundApp. All rights reserved.
//

import ARKit

class Sphere: SCNNode {
    
    enum State {
        case IDLE, FOCUS
    }
    
    var state: State!
    
    override init() {
        super.init()
        guard let scn = SCNScene(named: "Sphere.scn"),
            let sphere = scn.rootNode.childNode(withName: "Sphere", recursively: true) else {
                fatalError("Could not load scene")
        }
        
        addChildNode(sphere)
        
        sphere.scale = SCNVector3(0.35, 0.35, 0.35)
        startIdleAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startIdleAnimation() {
        guard state != .IDLE else { return }
        state = .IDLE
        let rotatePi = SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi), z: 0, duration: 5)
        let hoverUp = SCNAction.moveBy(x: 0, y: 0.2, z: 0, duration: 2.5)
        let hoverDown = SCNAction.moveBy(x: 0, y: -0.2, z: 0, duration: 2.5)
        
        let upDownSequence = SCNAction.sequence([hoverUp, hoverDown])
        let group = SCNAction.group([rotatePi, upDownSequence])
        
        let loop = SCNAction.repeatForever(group)
        runAction(loop)
    }
    
    func didUpdateCameraPosition(_ camera: ARCamera) {
        state = .FOCUS
        var transform = -camera.transform
        transform.columns.3.x = position.x
        transform.columns.3.y = position.y
        transform.columns.3.z = position.z
        
        self.transform = SCNMatrix4(transform)
    }
}

extension Sphere {
    static func insertBalls() -> [Sphere] {
        return (0..<3).map { _ in
            let sphere = Sphere()
            sphere.transform.m41 = Float.random(in: -1.5...1.5) // X
            sphere.transform.m42 = Float.random(in: -1.5...1.5) // Y
            sphere.transform.m43 = -1.8//-1 * Float.random(in: 2.5...4.5) // Z
            return sphere
        }
        
    }
}
