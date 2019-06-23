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
    var spheres: [Sphere] = []
    
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
        let sphere = Sphere()
        sceneView.prepare([sphere]) { [weak self] _ in
            self?.spheres.append(sphere)
            self?.sceneView.scene.rootNode.addChildNode(sphere)
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
        
        guard let cameraOrientation = session.currentFrame?.camera.transform else { return }
        
    }
}
