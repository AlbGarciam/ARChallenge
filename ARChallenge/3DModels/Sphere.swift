//
//  Sphere.swift
//  ARChallenge
//
//  Created by Alberto García-Muñoz on 23/06/2019.
//  Copyright © 2019 SoundApp. All rights reserved.
//

import ARKit

class Sphere: SCNNode {
    
    override init() {
        super.init()
        guard let scn = SCNScene(named: "Sphere.scn"),
            let sphere = scn.rootNode.childNode(withName: "Sphere", recursively: true) else {
                fatalError("Could not load scene")
        }
        
        addChildNode(sphere)
        
        transform.m43 -= 2 // -1 * Float.random(in: 1...1.5) // Z
        
        sphere.scale = SCNVector3(0.25, 0.25, 0.25)
        startIdleAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func startIdleAnimation() {
        let rotatePi = SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi), z: 0, duration: 5)
        let hoverUp = SCNAction.moveBy(x: 0, y: 0.2, z: 0, duration: 2.5)
        let hoverDown = SCNAction.moveBy(x: 0, y: -0.2, z: 0, duration: 2.5)
        
        let upDownSequence = SCNAction.sequence([hoverUp, hoverDown])
        let group = SCNAction.group([rotatePi, upDownSequence])
        
        let loop = SCNAction.repeatForever(group)
        runAction(loop)
    }
    
    private func face(to cameraOrientation: simd_float4x4) {
        
        var transform = cameraOrientation
        transform.columns.3.x = position.x
        transform.columns.3.y = position.y
        transform.columns.3.z = position.z
        
        self.transform = SCNMatrix4(transform)
        
    }
    
    func didUpdateCameraPosition(_ camera: simd_float4x4) {
        face(to: camera)
    }
}

extension Sphere {
    static func insertBalls() {
    // Position the item
    //    transform.m41 = Float.random(in: -1...1) // X
    //    transform.m42 = Float.random(in: -1...1) // Y
    //    transform.m43 = -1 * Float.random(in: 1...1.5) // Z
    }
}
