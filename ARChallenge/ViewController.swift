//
//  ViewController.swift
//  ARChallenge
//
//  Created by Alberto García-Muñoz on 23/06/2019.
//  Copyright © 2019 SoundApp. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController {
    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard ARWorldTrackingConfiguration.isSupported else { return displayError() }
        
        startTracking()
        sceneView.session.delegate = self
        
        configureLights() 
        
        addSpheres()
        
        UIApplication.shared.isIdleTimerDisabled = true
        
    }
    
    private func addSpheres() {
        let spheres = Sphere.insertBalls()
        sceneView.prepare(spheres) { [weak self] _ in
            spheres.forEach{ self?.sceneView.scene.rootNode.addChildNode($0) }
        }
    }
    
    private func configureLights() {
        sceneView.automaticallyUpdatesLighting = true
        sceneView.autoenablesDefaultLighting = true
    }

    private func displayError() {
        let alert = UIAlertController.init(title: "Device not supported",
                                           message: "Your device is not supported",
                                           preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
    }

    private func startTracking() {
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
}

extension ViewController: ARSessionDelegate {
    func sessionInterruptionEnded(_ session: ARSession) {
        startTracking()
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        startTracking()
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        
        guard let camera = session.currentFrame?.camera else { return }
        let rootNode = sceneView.scene.rootNode
        let spheres = rootNode.childNodes.filter{ $0 is Sphere } as! [Sphere]
        
        spheres.forEach { (sphere) in
            let isFar = sphere.distance(to: camera) > 1.8
            isFar ? sphere.startIdleAnimation() : sphere.didUpdateCameraPosition(camera)
        }
        
    }
}
