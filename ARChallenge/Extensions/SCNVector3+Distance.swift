//
//  SCNVector3+Distance.swift
//  ARChallenge
//
//  Created by Alberto García-Muñoz on 23/06/2019.
//  Copyright © 2019 SoundApp. All rights reserved.
//

import ARKit

extension SCNVector3 {
    func distanceMatrix(_ matrix: simd_float4x4) -> Float {
        let matrixPos = matrix.columns.3
        return sqrt(pow(x-matrixPos.x, 2) + pow(y-matrixPos.y, 2) + pow(z-matrixPos.z, 2))
    }
}
