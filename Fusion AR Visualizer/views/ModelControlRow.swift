//
//  ExpandingButton.swift
//  Fusion AR Visualizer
//
//  Created by Theo Chemel on 5/31/19.
//  Copyright © 2019 Theo Chemel. All rights reserved.
//

import Foundation
import UIKit

class ModelControlRow: UIView {
    
    var modelScaleButton: UIView!
    var modelLightingButton: UIView!
    var modelRotationButton: UIView!
    
    var modelScaleSlider: UISlider!
    var modelLightingSlider: UISlider!
    var modelRotationSlider: UISlider!
    
    var modelScaleButtonWidthConstraint: NSLayoutConstraint!
    var modelLightingButtonWidthConstraint: NSLayoutConstraint!
    var modelRotationButtonWidthConstraint: NSLayoutConstraint!
    
    
    var modelScaleButtonIsExpanded = false
    var modelLightingButtonIsExpanded = false
    var modelRotationButtonIsExpanded = false
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        modelScaleButton = {
            let button = UIView()
            button.backgroundColor = .controlButton
            button.layer.cornerRadius = 20.0
            button.layer.masksToBounds = true
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(modelScaleButtonDidTap(_:)))
            button.addGestureRecognizer(tapGestureRecognizer)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        addSubview(modelScaleButton)
        
        modelScaleButtonWidthConstraint = modelScaleButton.widthAnchor.constraint(equalToConstant: 40.0)
        
        NSLayoutConstraint.activate([
            modelScaleButtonWidthConstraint,
            modelScaleButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            modelScaleButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            modelScaleButton.heightAnchor.constraint(equalToConstant: 40.0),
        ])
        
        modelScaleSlider = {
            let slider = UISlider()
            slider.translatesAutoresizingMaskIntoConstraints = false
            slider.alpha = 0.0
            return slider
        }()
        modelScaleButton.addSubview(modelScaleSlider)
        
        NSLayoutConstraint.activate([
            modelScaleSlider.trailingAnchor.constraint(equalTo: modelScaleButton.trailingAnchor, constant: -48.0),
            modelScaleSlider.widthAnchor.constraint(equalToConstant: 184.0),
            modelScaleSlider.heightAnchor.constraint(equalToConstant: 32.0),
            modelScaleSlider.centerYAnchor.constraint(equalTo: modelScaleButton.centerYAnchor),
        ])
        
        modelLightingButton = {
            let button = UIView()
            button.backgroundColor = .controlButton
            button.layer.cornerRadius = 20.0
            button.layer.masksToBounds = true
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(modelLightingButtonDidTap(_:)))
            button.addGestureRecognizer(tapGestureRecognizer)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        addSubview(modelLightingButton)
        
        modelLightingButtonWidthConstraint = modelLightingButton.widthAnchor.constraint(equalToConstant: 40.0)
        
        NSLayoutConstraint.activate([
            modelLightingButtonWidthConstraint,
            modelLightingButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            modelLightingButton.bottomAnchor.constraint(equalTo: modelScaleButton.topAnchor, constant: -16.0),
            modelLightingButton.heightAnchor.constraint(equalToConstant: 40.0),
        ])
        
        modelLightingSlider = {
            let slider = UISlider()
            slider.translatesAutoresizingMaskIntoConstraints = false
            slider.alpha = 0.0
            return slider
        }()
        modelLightingButton.addSubview(modelLightingSlider)
        
        NSLayoutConstraint.activate([
            modelLightingSlider.trailingAnchor.constraint(equalTo: modelLightingButton.trailingAnchor, constant: -48.0),
            modelLightingSlider.widthAnchor.constraint(equalToConstant: 184.0),
            modelLightingSlider.heightAnchor.constraint(equalToConstant: 32.0),
            modelLightingSlider.centerYAnchor.constraint(equalTo: modelLightingButton.centerYAnchor),
        ])
        
        modelRotationButton = {
            let button = UIView()
            button.backgroundColor = .controlButton
            button.layer.cornerRadius = 20.0
            button.layer.masksToBounds = true
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(modelRotationButtonDidTap(_:)))
            button.addGestureRecognizer(tapGestureRecognizer)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        addSubview(modelRotationButton)
        
        modelRotationButtonWidthConstraint = modelRotationButton.widthAnchor.constraint(equalToConstant: 40.0)
        
        NSLayoutConstraint.activate([
            modelRotationButtonWidthConstraint,
            modelRotationButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            modelRotationButton.bottomAnchor.constraint(equalTo: modelLightingButton.topAnchor, constant: -16.0),
            modelRotationButton.heightAnchor.constraint(equalToConstant: 40.0),
        ])
        
        modelRotationSlider = {
            let slider = UISlider()
            slider.translatesAutoresizingMaskIntoConstraints = false
            slider.alpha = 0.0
            return slider
        }()
        modelRotationButton.addSubview(modelRotationSlider)
        
        NSLayoutConstraint.activate([
            modelRotationSlider.trailingAnchor.constraint(equalTo: modelRotationButton.trailingAnchor, constant: -48.0),
            modelRotationSlider.widthAnchor.constraint(equalToConstant: 184.0),
            modelRotationSlider.heightAnchor.constraint(equalToConstant: 32.0),
            modelRotationSlider.centerYAnchor.constraint(equalTo: modelRotationButton.centerYAnchor)
        ])
    }
    
    @objc func modelScaleButtonDidTap(_ sender: UIView) {
        if modelScaleButtonIsExpanded {
            modelScaleButtonIsExpanded = false
            UIView.animate(withDuration: 0.2) {
                self.modelScaleButtonWidthConstraint.constant = 40.0
                self.modelScaleSlider.alpha = 0.0
                self.layoutIfNeeded()
            }
        } else {
            modelScaleButtonIsExpanded = true
            UIView.animate(withDuration: 0.2) {
                self.modelScaleButtonWidthConstraint.constant = 240.0
                self.modelScaleSlider.alpha = 1.0
                self.layoutIfNeeded()
            }
        }
    }
    
    @objc func modelLightingButtonDidTap(_ sender: UIView) {
        if modelLightingButtonIsExpanded {
            modelLightingButtonIsExpanded = false
            
            UIView.animate(withDuration: 0.2) {
                self.modelLightingButtonWidthConstraint.constant = 40.0
                self.modelLightingSlider.alpha = 0.0
                self.layoutIfNeeded()
            }
            
        } else {
            modelLightingButtonIsExpanded = true
            
            UIView.animate(withDuration: 0.2) {
                self.modelLightingButtonWidthConstraint.constant = 240.0
                self.modelLightingSlider.alpha = 1.0
                self.layoutIfNeeded()
            }
        }
    }
    
    @objc func modelRotationButtonDidTap(_ sender: UIView) {
        if modelRotationButtonIsExpanded {
            modelRotationButtonIsExpanded = false
            
            UIView.animate(withDuration: 0.2) {
                self.modelRotationButtonWidthConstraint.constant = 40.0
                self.modelRotationSlider.alpha = 0.0
                self.layoutIfNeeded()
            }
            
        } else {
            modelRotationButtonIsExpanded = true
            
            UIView.animate(withDuration: 0.2) {
                self.modelRotationButtonWidthConstraint.constant = 240.0
                self.modelRotationSlider.alpha = 1.0
                self.layoutIfNeeded()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
