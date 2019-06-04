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
    
    let controlViewController = ControlViewController()
    
    var model: SCNNode?
    
    var currentModelPosition: simd_float4x4?
    
    var currentModelMaterial: SCNMaterial = {
        let material = SCNMaterial()
        material.lightingModel = .physicallyBased
        material.diffuse.contents = UIColor.gray
        material.metalness.contents = UIColor.gray
        material.emission.contents = UIColor.black
        return material
    }()
    
    var currentModelRotation: Float = 0.0
    
    var currentModelScale: Float = 10.0
    
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
        
        if let hitTestResult = sceneView.hitTest(CGPoint(x: view.bounds.midX, y: view.bounds.midY), types: [.estimatedHorizontalPlane, .existingPlaneUsingExtent]).first,
            let planeAnchor = hitTestResult.anchor as? ARPlaneAnchor {
        
            guard let modelData = latestSTLData else { return }
            currentModelPosition = hitTestResult.worldTransform
            setModel(modelData: modelData, position: hitTestResult.worldTransform, material: currentModelMaterial, scale: currentModelScale, rotation: currentModelRotation)
        } else {
            guard let modelData = latestSTLData else { return }
            guard let camera = sceneView.pointOfView else { return }
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -0.5
            currentModelPosition = matrix_multiply(camera.simdTransform, translation)
            setModel(modelData: modelData, position: currentModelPosition!, material: currentModelMaterial, scale: currentModelScale, rotation: currentModelRotation)
        }
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocket is connected")
        controlViewController.setConnectionStatus(isConnected: true)
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("websocket is disconnected, retrying...")
        controlViewController.setConnectionStatus(isConnected: false)
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
        guard let position = currentModelPosition else { return }
        
        setModel(modelData: data, position: position, material: currentModelMaterial, scale: currentModelScale, rotation: currentModelRotation)
    }
    
    func setModel(modelData: Data, position: simd_float4x4, material: SCNMaterial, scale: Float, rotation: Float) {
        guard let model = try? BinarySTLParser.createNodeFromSTL(withData: modelData, unit: .millimeter) else {
            print("Error parsing STL")
            return
        }
        
        for child in sceneView.scene.rootNode.childNodes {
            child.removeFromParentNode()
        }
        
        model.geometry?.materials = [material]
        
        model.simdWorldTransform = position
        
        
        let (minVec, maxVec) = model.boundingBox
        model.pivot = SCNMatrix4MakeTranslation((maxVec.x - minVec.x) / 2 + minVec.x, (maxVec.y - minVec.y) / 2 + minVec.y, 0)
        
        model.scale = SCNVector3(scale, scale, scale)
        model.rotation = SCNVector4(0.0, rotation, 0.0, rotation)
        
        sceneView.scene.rootNode.addChildNode(model)
        
        self.model = model
        
        print("Set model")
    }
    
    func updateModelPosition(position: simd_float4x4) {
        currentModelPosition = position
        guard let node = model else { return }
        node.simdWorldTransform = position
    }
    
    func updateModelScale(scale: Float) {
        currentModelScale = scale
        SCNTransaction.animationDuration = 0.1
        model?.scale = SCNVector3(scale, scale, scale)
    }
    
    func updateModelRotation(rotation: Float) {
        currentModelRotation = rotation
        
        guard let node = model else { return }
        
        SCNTransaction.animationDuration = 0.1
        let (minVec, maxVec) = node.boundingBox
        node.pivot = SCNMatrix4MakeTranslation((maxVec.x - minVec.x) / 2 + minVec.x, (maxVec.y - minVec.y) / 2 + minVec.y, 0)
        node.rotation = SCNVector4(0.0, rotation, 0.0, rotation)

    }
    
    func shouldChangeModelScale(_ scale: Float) {
        updateModelScale(scale: scale)
    }
    
    func shouldChangeModelRotation(_ rotation: Float) {
        updateModelRotation(rotation: rotation)
    }
}
