//
//  ViewController.swift
//  Fusion AR Visualizer
//
//  Created by Theo Chemel on 5/23/19.
//  Copyright © 2019 Theo Chemel. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Starscream

class ARViewController: UIViewController, ARSCNViewDelegate, WebSocketDelegate, ARControlsDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var socket = WebSocket(url: URL(string: "ws://Macbook-Pro-5.local:8080/connect")!)

    var latestSTLData: Data?
    
    var currentMaterial: SCNMaterial = {
        let material = SCNMaterial()
        material.lightingModel = .physicallyBased
        material.diffuse.contents = UIColor.gray
        material.metalness.contents = UIColor.gray
        material.emission.contents = UIColor.black
        return material
    }()
    
    var currentModelPosition: simd_float4x4?
    
    var currentModelScale = SCNVector3(40, 40, 40)
    
    var currentModelRotation: Float = 0.0
    
    var isInPlaceMode = false
    
    let controlViewController = ControlViewController()
    
    var model: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controlViewController.delegate = self
        
        socket.delegate = self
        socket.connect()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        sceneView.autoenablesDefaultLighting = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        view.addGestureRecognizer(gestureRecognizer)
        
        isInPlaceMode = true
        
        addChild(controlViewController)
        view.addSubview(controlViewController.view)
        
        controlViewController.setConnectionStatus(isConnected: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        
        sceneView.session.run(configuration)
    }
    
    @objc func didTap(_ recognizer: UITapGestureRecognizer) {
        print("Tap")
        
        if isInPlaceMode {
            
            guard let hitTestResult = sceneView.hitTest(recognizer.location(in: sceneView), types: [.estimatedHorizontalPlane, .existingPlaneUsingExtent]).first,
                let planeAnchor = hitTestResult.anchor as? ARPlaneAnchor
                else {
                    // Place in front of camera
                    return
            }
            
            currentModelPosition = hitTestResult.worldTransform
            updateModelIfNeeded()
            
        }
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocket is connected")
        controlViewController.setConnectionStatus(isConnected: true)
        // Update UI
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("websocket is disconnected, retrying...")
        controlViewController.setConnectionStatus(isConnected: false)
        // Update UI
        let timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (_) in
            socket.connect()
        }
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("websocket recieved message: \(text)")
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("websocket recieved data: \(data.count)")
        
        latestSTLData = data
        
        updateModelIfNeeded()
    }
    
    func updateModelIfNeeded() {
        guard let data = latestSTLData else { return }
        guard let node = try? BinarySTLParser.createNodeFromSTL(withData: data, unit: .millimeter) else {
            print("Error parsing STL")
            return
        }
        guard let position = currentModelPosition else { return }
        
        for child in sceneView.scene.rootNode.childNodes {
            child.removeFromParentNode()
        }
        
        node.geometry?.materials = [currentMaterial]
        
        node.simdWorldTransform = position
        node.scale = currentModelScale
        
        model = node
        
        sceneView.scene.rootNode.addChildNode(node)
        
        print("Updated model")
    }
    
    func updateModelScale() {
        guard let node = model else { return }
        
        SCNTransaction.animationDuration = 0.1
        node.scale = currentModelScale
    }
    
    func updateModelRotation() {
        guard let node = model else { return }
        
        SCNTransaction.animationDuration = 0.1
        node.rotation = SCNVector4(currentModelRotation, 0.0, 0.0, 0.0)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("New plane anchor: \(anchor.transform)")
    }
    
    // MARK: Delegate methods for ARControlsDelegate
    
    func shouldChangeModelScale(_ value: Float) {
        print("Change model scale: \(value)")
        currentModelScale = SCNVector3(x: value, y: value, z: value)
        updateModelScale()
    }
    
    func shouldChangeModelLighting(_ value: Float) {
        print("Change model lighting: \(value)")
    }
    
    func shouldChangeModelRotation(_ value: Float) {
        print("Change model rotation: \(value)")
        currentModelRotation = value
        updateModelRotation()
    }
    
}
