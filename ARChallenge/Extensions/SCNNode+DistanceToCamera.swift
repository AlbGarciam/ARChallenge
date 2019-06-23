//
//  SCNNode+DistanceToCamera.swift
//  ARChallenge
//
//  Created by Alberto García-Muñoz on 23/06/2019.
//  Copyright © 2019 SoundApp. All rights reserved.
//

import ARKit

extension SCNNode {
    func distance(to camera: ARCamera) -> Float {
        let transformCamera = camera.transform
        return position.distanceMatrix(transformCamera)
    }
}
